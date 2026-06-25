import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants.dart';
import '../../models/inference_result.dart';
import '../widgets/treatment_card.dart';
import '../widgets/scanner_overlay.dart';
import '../../models/plant_scan_model.dart';
import '../../models/scan_history.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../services/auth_service.dart';
import '../../services/inference_service.dart';
import '../../services/database_service.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;

  const ResultScreen({super.key, required this.imagePath});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isAnalyzing = true;
  String? _errorMessage;
  String? _saveWarning;
  InferenceResult? _inferenceResult;
  double? _imageAspectRatio;

  final InferenceService _inferenceService = InferenceService();
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _resolveImageAspectRatio();
    _analyzeImage();
  }

  // Decode the photo's real dimensions so the preview box (and the scanner
  // frame painted over it) can match the photo's aspect ratio exactly.
  Future<void> _resolveImageAspectRatio() async {
    final provider = FileImage(File(widget.imagePath));
    final stream = provider.resolve(const ImageConfiguration());
    final completer = Completer<ui.Image>();
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        if (!completer.isCompleted) completer.complete(info.image);
        stream.removeListener(listener);
      },
      onError: (Object error, StackTrace? stack) {
        if (!completer.isCompleted) completer.completeError(error);
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);

    try {
      final image = await completer.future;
      if (!mounted || image.height == 0) return;
      setState(() {
        _imageAspectRatio = image.width / image.height;
      });
    } catch (_) {
      // Keep the default aspect ratio if decoding fails.
    }
  }

  Future<void> _analyzeImage() async {
    HapticFeedback.lightImpact();

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
      _saveWarning = null;
    });

    try {
      final result = await _inferenceService.predictFromImage(widget.imagePath);

      HapticFeedback.mediumImpact();

      _inferenceResult = result;
      unawaited(_saveScanToCloudInBackground(result));
    } catch (e) {
      _errorMessage = 'Analiz başarısız: $e';
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  Future<void> _saveScanToCloud(InferenceResult result) async {
    final user = _authService.currentUser;
    if (user == null) return;

    final scanDate = DateTime.now();

    // 1) Cache locally first (Isar) so the scan survives with no network and
    //    the photo stays viewable offline in My Garden.
    final localScan = ScanHistory()
      ..userId = user.uid
      ..imagePath = await _persistScanImageLocally()
      ..plantType = result.plantType
      ..diseaseName = result.diseaseName
      ..rawLabel = result.rawLabel
      ..confidence = result.confidence
      ..scanDate = scanDate;
    await DatabaseService.saveScan(localScan);

    // 2) Mirror to the cloud: image -> Firebase Storage, record -> Firestore.
    final imageUrl = await _storageService.uploadImage(
      File(widget.imagePath),
      'plant_scans',
      user.uid,
    );

    if (imageUrl == null) return;

    final scan = PlantScanModel(
      userId: user.uid,
      date: scanDate,
      imageUrl: imageUrl,
      plantTypeId: result.plantType,
      plantIllnessId: result.diseaseName,
      notes:
          'Model: ${result.rawLabel} | Confidence: %${(result.confidence * 100).toStringAsFixed(2)}',
    );

    final firestoreId = await _firestoreService.addPlantScan(scan);

    // 3) Link the local copy to the cloud record (delete sync + remote URL).
    localScan
      ..cloudImageUrl = imageUrl
      ..firestoreId = firestoreId;
    await DatabaseService.saveScan(localScan);
  }

  /// Copies the captured photo into the app documents directory so the local
  /// (offline) history keeps working after temp/cache files are cleared.
  Future<String> _persistScanImageLocally() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final scansDir = Directory('${docsDir.path}/scan_images');
      if (!await scansDir.exists()) {
        await scansDir.create(recursive: true);
      }
      final dotIndex = widget.imagePath.lastIndexOf('.');
      final ext =
          dotIndex == -1 ? 'jpg' : widget.imagePath.substring(dotIndex + 1);
      final dest =
          '${scansDir.path}/${DateTime.now().millisecondsSinceEpoch}.$ext';
      await File(widget.imagePath).copy(dest);
      return dest;
    } catch (_) {
      // Fall back to the original path if copying fails; better than losing
      // the record entirely.
      return widget.imagePath;
    }
  }

  Future<void> _saveScanToCloudInBackground(InferenceResult result) async {
    try {
      await _saveScanToCloud(result).timeout(const Duration(seconds: 60));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saveWarning =
            'Sonuç gösterildi; yerel kopya alındı, buluta kaydedilemedi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size the preview to the photo's real aspect ratio, bounded to the
    // available width and half the screen height (so tall portrait photos
    // don't take over the screen). Because the box matches the image ratio,
    // BoxFit.cover fills it with no cropping and the scanner frame hugs the photo.
    final mediaSize = MediaQuery.of(context).size;
    final availableWidth = mediaSize.width - AppPadding.lg * 2;
    final maxImageHeight = mediaSize.height * 0.5;
    final imageAspectRatio = _imageAspectRatio ?? 1.0;
    double imageWidth = availableWidth;
    double imageHeight = imageWidth / imageAspectRatio;
    if (imageHeight > maxImageHeight) {
      imageHeight = maxImageHeight;
      imageWidth = imageHeight * imageAspectRatio;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analysis Result"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display the cropped image, sized to match its real aspect
              // ratio so the scanner frame wraps the photo exactly (no crop).
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'croppedImage',
                    child: InteractiveViewer(
                      panEnabled: true,
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: ScannerOverlay(
                              isScanning: _isAnalyzing,
                              child: Image.file(
                                File(widget.imagePath),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppPadding.xl),

              // Analysis Section
              if (_isAnalyzing)
                Column(
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: AppPadding.md),
                    Shimmer.fromColors(
                      baseColor: AppColors.textMain,
                      highlightColor: AppColors.primaryLight,
                      child: const Text(
                        "Analyzing Leaf Patterns...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              else if (_errorMessage != null)
                Column(
                  children: [
                    const Icon(
                      Icons.error_rounded,
                      color: AppColors.diseased,
                      size: 64,
                    ),
                    const SizedBox(height: AppPadding.sm),
                    const Text(
                      'Model bağlantısı başarısız',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: AppPadding.sm),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppPadding.lg),
                    ElevatedButton.icon(
                      onPressed: _analyzeImage,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Tekrar Dene'),
                    ),
                  ],
                )
              else ...[
                if (_saveWarning != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: AppPadding.md),
                    padding: const EdgeInsets.all(AppPadding.md),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      _saveWarning!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                // Real Model Result Card
                Container(
                  padding: const EdgeInsets.all(AppPadding.lg),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryLight.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _inferenceResult!.isHealthy
                            ? Icons.check_circle_rounded
                            : Icons.warning_amber_rounded,
                        color:
                            _inferenceResult!.isHealthy
                                ? AppColors.healthy
                                : AppColors.diseased,
                        size: 64,
                      ),
                      const SizedBox(height: AppPadding.sm),
                      Text(
                        _inferenceResult!.diseaseName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: AppPadding.sm),
                      Text(
                        'Bitki: ${_inferenceResult!.plantType}\nGüven: %${(_inferenceResult!.confidence * 100).toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Tedavi / Önleme Kartı ─────────────────────────────────
                const SizedBox(height: AppPadding.lg),
                TreatmentCard(rawLabel: _inferenceResult!.rawLabel),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

