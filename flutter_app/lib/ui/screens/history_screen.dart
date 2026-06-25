import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/plant_scan_model.dart';
import '../../models/scan_history.dart';
import '../../services/firestore_service.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'full_screen_image_screen.dart';
import '../widgets/treatment_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirestoreService _db = FirestoreService();
  final AuthService _auth = AuthService();

  bool _hasScans = false;

  // notes alanı "Model: Apple___Apple_scab | Confidence: ..." formatındadır.
  String? _rawLabelFromNotes(String? notes) {
    if (notes == null) return null;
    final match = RegExp(r'Model:\s*(.+?)\s*\|').firstMatch(notes);
    return match?.group(1)?.trim();
  }

  void _showTreatmentSheet(String rawLabel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Tutaç
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(
                      AppPadding.lg, 0, AppPadding.lg, AppPadding.xl),
                  children: [
                    TreatmentCard(
                      rawLabel: rawLabel,
                      initiallyExpanded: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Keeps the app-bar "clear all" button in sync with the stream without
  // calling setState during build.
  void _syncHasScans(bool value) {
    if (_hasScans == value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _hasScans != value) {
        setState(() => _hasScans = value);
      }
    });
  }

  Future<bool> _confirm(String title, String message, String confirmLabel) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.diseased),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _deleteScan(PlantScanModel scan) async {
    if (scan.plantId == null) return;
    try {
      await _db.deletePlantScan(scan.plantId!);
      // Keep the local (offline) cache in sync.
      await DatabaseService.deleteByFirestoreId(scan.plantId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarama silindi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Silme başarısız: $e')),
        );
      }
    }
  }

  Future<void> _clearAll(String userId) async {
    final ok = await _confirm(
      'Bahçeyi temizle',
      'Tüm tarama geçmişiniz kalıcı olarak silinecek. Emin misiniz?',
      'Tümünü Sil',
    );
    if (!ok) return;
    try {
      await _db.clearAllPlantScans(userId);
      // Keep the local (offline) cache in sync.
      await DatabaseService.clearForUser(userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bahçe temizlendi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Temizleme başarısız: $e')),
        );
      }
    }
  }

  // Offline view backed by the local Isar cache. Shown when the Firestore
  // stream errors (no connection / query failure). Photos are read from the
  // device, so they render even with no network.
  Widget _buildOfflineFallback(String userId) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.diseased.withValues(alpha: 0.08),
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.lg, vertical: AppPadding.sm),
          child: const Row(
            children: [
              Icon(Icons.cloud_off_rounded,
                  size: 18, color: AppColors.diseased),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Çevrimdışı — cihazdaki yerel kopya gösteriliyor',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ScanHistory>>(
            stream: DatabaseService.watchUserScans(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              final scans = snapshot.data ?? const <ScanHistory>[];
              if (scans.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.lg),
                    child: Text(
                      'Çevrimdışı görüntülenecek yerel tarama kaydı yok.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(AppPadding.md),
                itemCount: scans.length,
                itemBuilder: (context, index) =>
                    _buildOfflineCard(scans[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineCard(ScanHistory scan) {
    final dateStr =
        "${scan.scanDate.day}/${scan.scanDate.month}/${scan.scanDate.year}";
    final isHealthy = scan.diseaseName.toLowerCase().contains('healthy');
    final statusColor = isHealthy ? AppColors.healthy : AppColors.diseased;

    return Card(
      margin: const EdgeInsets.only(bottom: AppPadding.md),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppPadding.sm),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(scan.imagePath),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              child: const Icon(Icons.broken_image, color: AppColors.primary),
            ),
          ),
        ),
        title: Text(
          scan.diseaseName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Scanned on $dateStr'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                scan.plantType,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (scan.rawLabel.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.healing_rounded,
                    color: AppColors.primary, size: 22),
                tooltip: 'Tedavi önerileri',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                onPressed: () => _showTreatmentSheet(scan.rawLabel),
              ),
            IconButton(
              icon: Icon(Icons.delete_outline,
                  color: AppColors.diseased.withValues(alpha: 0.7), size: 22),
              tooltip: 'Sil',
              onPressed: () async {
                final ok = await _confirm(
                  'Taramayı sil',
                  'Bu yerel tarama kaydı silinecek. Emin misiniz?',
                  'Sil',
                );
                if (ok) await DatabaseService.deleteScan(scan.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view your history')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'My Garden',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_hasScans)
            IconButton(
              tooltip: 'Bahçeyi temizle',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _clearAll(user.uid),
            ),
        ],
      ),
      body: StreamBuilder<List<PlantScanModel>>(
        stream: _db.getUserPlantScans(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          // Cloud read failed (offline / error): fall back to the local Isar
          // cache so My Garden still shows past scans (with offline photos).
          if (snapshot.hasError) {
            return _buildOfflineFallback(user.uid);
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            _syncHasScans(false);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                           BoxShadow(
                             color: AppColors.primary.withValues(alpha: 0.1),
                             blurRadius: 40,
                             spreadRadius: 10,
                           ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.yard_outlined,
                          size: 64,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppPadding.xl),
                    Text(
                      "Your Garden is Empty",
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        color: AppColors.textMain,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppPadding.md),
                    const Text(
                      "Every great garden starts with a single seedling.\nSnap a photo of your first leaf to begin tracking.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final scans = snapshot.data!;
          _syncHasScans(true);

          return ListView.builder(
            padding: const EdgeInsets.all(AppPadding.md),
            itemCount: scans.length,
            itemBuilder: (context, index) {
              final scan = scans[index];
              final dateStr = "${scan.date.day}/${scan.date.month}/${scan.date.year}";

              final isHealthy = scan.plantIllnessId.toLowerCase().contains('healthy');
              final statusColor = isHealthy ? AppColors.healthy : AppColors.diseased;

              return Dismissible(
                key: ValueKey(
                  scan.plantId ?? scan.date.millisecondsSinceEpoch.toString(),
                ),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(bottom: AppPadding.md),
                  padding: const EdgeInsets.symmetric(horizontal: AppPadding.lg),
                  decoration: BoxDecoration(
                    color: AppColors.diseased,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                confirmDismiss: (_) => _confirm(
                  'Taramayı sil',
                  'Bu tarama kaydı silinecek. Emin misiniz?',
                  'Sil',
                ),
                onDismissed: (_) => _deleteScan(scan),
                child: Card(
                margin: const EdgeInsets.only(bottom: AppPadding.md),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(AppPadding.sm),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: 'scan_image_${scan.plantId ?? scan.date.millisecondsSinceEpoch}',
                      child: Image.network(
                        scan.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: AppColors.primaryLight.withValues(alpha: 0.2),
                            child: const Icon(Icons.broken_image, color: AppColors.primary),
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    scan.plantIllnessId,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Scanned on $dateStr'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          scan.plantTypeId,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Tedavi butonu
                      if (_rawLabelFromNotes(scan.notes) != null)
                        IconButton(
                          icon: const Icon(
                            Icons.healing_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          tooltip: 'Tedavi önerileri',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          onPressed: () => _showTreatmentSheet(
                              _rawLabelFromNotes(scan.notes)!),
                        ),
                      const SizedBox(width: 0),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.diseased.withValues(alpha: 0.7),
                          size: 22,
                        ),
                        tooltip: 'Sil',
                        onPressed: () async {
                          final ok = await _confirm(
                            'Taramayı sil',
                            'Bu tarama kaydı silinecek. Emin misiniz?',
                            'Sil',
                          );
                          if (ok) _deleteScan(scan);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    if (scan.imageUrl.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullScreenImageScreen(
                            imageUrl: scan.imageUrl,
                            heroTag: 'scan_image_${scan.plantId ?? scan.date.millisecondsSinceEpoch}',
                          ),
                        ),
                      );
                    }
                  },
                ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
