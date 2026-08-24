import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../core/network/upload_repository.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/face_match.dart';
import '../application/seller_onboarding_controller.dart';

enum _Stage { initializing, lookNormal, blink, processing, failed }

/// Step 3 (the last one) of the become-a-seller wizard: a live front-camera
/// capture, compared on-device (Google ML Kit, free — no paid KYC vendor)
/// against the "selfie with passport" photo from step 2, plus a two-frame
/// blink check as a liveness-lite signal against a printed-photo spoof. See
/// face_match.dart and SellerApplicationService's doc comment (Go side) for
/// the honest limits of this free/on-device approach.
///
/// Camera lifecycle and ML Kit calls live here, in the screen's State,
/// rather than in SellerOnboardingController — a CameraController is tied
/// to this screen's widget lifetime (must be disposed with it), which
/// doesn't fit a Riverpod Notifier that can outlive any one screen.
class SellerFaceLivenessScreen extends ConsumerStatefulWidget {
  const SellerFaceLivenessScreen({super.key});

  @override
  ConsumerState<SellerFaceLivenessScreen> createState() => _SellerFaceLivenessScreenState();
}

class _SellerFaceLivenessScreenState extends ConsumerState<SellerFaceLivenessScreen> {
  CameraController? _camera;
  _Stage _stage = _Stage.initializing;
  XFile? _openEyesFrame;
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(front, ResolutionPreset.medium, enableAudio: false);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = controller;
        _stage = _Stage.lookNormal;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _stage = _Stage.failed;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }

  Future<Face?> _detectSingleFace(String path) async {
    final detector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
    try {
      final faces = await detector.processImage(InputImage.fromFilePath(path));
      if (faces.length != 1) return null;
      return faces.first;
    } finally {
      await detector.close();
    }
  }

  Future<void> _capture() async {
    final camera = _camera;
    final l10n = AppLocalizations.of(context)!;
    if (camera == null || !camera.value.isInitialized) return;
    setState(() => _errorMessage = null);

    if (_stage == _Stage.lookNormal) {
      final file = await camera.takePicture();
      final face = await _detectSingleFace(file.path);
      if (!mounted) return;
      if (face == null) {
        setState(() => _errorMessage = l10n.sellerFaceFailed);
        return;
      }
      setState(() {
        _openEyesFrame = file;
        _stage = _Stage.blink;
      });
      return;
    }

    if (_stage == _Stage.blink) {
      setState(() => _stage = _Stage.processing);
      final blinkFrame = await camera.takePicture();
      await _finish(blinkFrame);
    }
  }

  Future<void> _finish(XFile blinkFrame) async {
    final l10n = AppLocalizations.of(context)!;
    final openFrame = _openEyesFrame;
    final passportSelfiePath = ref.read(sellerOnboardingControllerProvider).selfieWithPassportLocalPath;
    if (openFrame == null || passportSelfiePath == null) {
      setState(() {
        _stage = _Stage.failed;
        _errorMessage = l10n.sellerFaceFailed;
      });
      return;
    }

    final openFace = await _detectSingleFace(openFrame.path);
    final blinkFace = await _detectSingleFace(blinkFrame.path);
    final passportFace = await _detectSingleFace(passportSelfiePath);

    if (openFace == null || blinkFace == null || passportFace == null) {
      if (!mounted) return;
      setState(() {
        _stage = _Stage.failed;
        _errorMessage = l10n.sellerFaceFailed;
      });
      return;
    }

    final livenessPassed = detectedBlink(openFace, blinkFace);
    final score = computeFaceSimilarity(passportFace, openFace);

    setState(() => _isSubmitting = true);
    try {
      final key = await ref
          .read(uploadRepositoryProvider)
          .uploadImage(bytes: await openFrame.readAsBytes(), purpose: 'seller-kyc');
      if (!mounted) return;
      ref.read(sellerOnboardingControllerProvider.notifier).setLivenessResult(
            liveSelfieKey: key,
            passed: livenessPassed,
            score: score,
          );
      await ref.read(sellerOnboardingControllerProvider.notifier).submit();
      if (!mounted) return;
      final submitError = ref.read(sellerOnboardingControllerProvider).error;
      if (submitError != null) {
        setState(() {
          _isSubmitting = false;
          _stage = _Stage.failed;
          _errorMessage = l10n.sellerFaceFailed;
        });
        return;
      }
      context.go(RoutePaths.becomeSeller);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _stage = _Stage.failed;
        _errorMessage = l10n.sellerFaceFailed;
      });
    }
  }

  void _retry() {
    setState(() {
      _stage = _Stage.lookNormal;
      _openEyesFrame = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final camera = _camera;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellerFaceTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (camera != null && camera.value.isInitialized)
                        CameraPreview(camera)
                      else
                        const ColoredBox(color: Colors.black12, child: Center(child: CircularProgressIndicator())),
                      IgnorePointer(
                        child: Center(
                          child: Container(
                            width: 220,
                            height: 280,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white70, width: 2),
                              borderRadius: BorderRadius.circular(140),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                switch (_stage) {
                  _Stage.lookNormal => l10n.sellerFaceInstructionLookNormal,
                  _Stage.blink => l10n.sellerFaceInstructionBlink,
                  _Stage.processing => l10n.sellerFaceProcessing,
                  _ => '',
                },
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(_errorMessage!, style: const TextStyle(color: AppColors.error), textAlign: TextAlign.center),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (_stage == _Stage.failed)
                PrimaryButton(label: l10n.commonRetry, onPressed: _retry)
              else
                PrimaryButton(
                  label: l10n.sellerFaceCapture,
                  isLoading: _stage == _Stage.processing || _isSubmitting,
                  onPressed: camera == null || camera.value.isInitialized == false ? null : _capture,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
