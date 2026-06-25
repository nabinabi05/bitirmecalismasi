import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animations/animations.dart';
import 'package:camera/camera.dart';

import '../../core/constants.dart';
import '../widgets/primary_button.dart';
import 'result_screen.dart';
import 'custom_camera_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCustomCamera() async {
    try {
      final cameras = await availableCameras();
      if (!mounted) return;

      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder:
              (context, animation, secondaryAnimation) => FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: CustomCameraScreen(cameras: cameras),
              ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error accessing camera: $e')));
    }
  }

  Future<void> _processImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Leaf',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Leaf',
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: true,
            aspectRatioPickerButtonHidden: false,
          ),
        ],
      );

      if (croppedFile != null) {
        if (!mounted) return;

        // Navigate to the Results Screen with a smooth FadeThrough transition
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: ResultScreen(imagePath: croppedFile.path),
                    ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppPadding.xl),
              Text(
                'Plant\nCare AI',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 48,
                  height: 1.1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primaryLight
                      : AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: AppPadding.sm),
              Text(
                'Snap a photo of a sick leaf to instantly identify the disease.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Center(
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    size: 150,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Take a Photo',
                icon: Icons.camera_alt_rounded,
                onTap: _openCustomCamera,
              ),
              const SizedBox(height: AppPadding.md),
              Builder(
                builder: (context) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  final fgColor = isDark
                      ? AppColors.primaryLight
                      : AppColors.textMain;
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _processImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library_rounded, color: fgColor),
                      label: Text(
                        'Choose from Gallery',
                        style: TextStyle(
                          color: fgColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppPadding.md),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.primaryLight.withValues(alpha: 0.6)
                              : AppColors.textMain.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: isDark
                            ? AppColors.primaryLight.withValues(alpha: 0.07)
                            : Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppPadding.md),
            ],
          ),
        ),
      ),
    );
  }
}
