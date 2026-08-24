import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/network/upload_repository.dart';
import '../data/seller_application_repository.dart';
import '../models/seller_application.dart';

enum SellerDocumentSlot { passportFront, passportBack, selfieWithPassport }

/// Draft state for the become-a-seller wizard (store_info -> documents ->
/// face-liveness -> submit), held across all four screens by one Notifier
/// so a user can go back a step without losing what they already entered.
class SellerOnboardingState {
  const SellerOnboardingState({
    this.storeLat,
    this.storeLng,
    this.storeWebsite,
    this.storeInstagram,
    this.storeTelegram,
    this.storeWhatsapp,
    this.birthDate,
    this.passportFrontKey,
    this.passportBackKey,
    this.selfieWithPassportKey,
    this.selfieWithPassportLocalPath,
    this.liveSelfieKey,
    this.livenessPassed = false,
    this.faceMatchScore,
    this.isLocating = false,
    this.uploadingSlot,
    this.isSubmitting = false,
    this.error,
    this.submitted,
  });

  final double? storeLat;
  final double? storeLng;
  final String? storeWebsite;
  final String? storeInstagram;
  final String? storeTelegram;
  final String? storeWhatsapp;
  final DateTime? birthDate;
  final String? passportFrontKey;
  final String? passportBackKey;
  final String? selfieWithPassportKey;
  // Kept only in memory (never uploaded again) so the face-liveness step
  // can run on-device face detection against this exact photo — the
  // uploaded object key alone isn't enough since it isn't a local file.
  final String? selfieWithPassportLocalPath;
  final String? liveSelfieKey;
  final bool livenessPassed;
  final double? faceMatchScore;
  final bool isLocating;
  final SellerDocumentSlot? uploadingSlot;
  final bool isSubmitting;
  final AppException? error;
  final SellerApplication? submitted;

  bool get hasStoreInfo =>
      (storeLat != null && storeLng != null) ||
      _nonEmpty(storeWebsite) ||
      _nonEmpty(storeInstagram) ||
      _nonEmpty(storeTelegram) ||
      _nonEmpty(storeWhatsapp);

  bool get hasAllDocuments =>
      birthDate != null && passportFrontKey != null && passportBackKey != null && selfieWithPassportKey != null;

  static bool _nonEmpty(String? s) => s != null && s.trim().isNotEmpty;

  SellerOnboardingState copyWith({
    double? storeLat,
    double? storeLng,
    String? storeWebsite,
    String? storeInstagram,
    String? storeTelegram,
    String? storeWhatsapp,
    DateTime? birthDate,
    String? passportFrontKey,
    String? passportBackKey,
    String? selfieWithPassportKey,
    String? selfieWithPassportLocalPath,
    String? liveSelfieKey,
    bool? livenessPassed,
    double? faceMatchScore,
    bool? isLocating,
    SellerDocumentSlot? uploadingSlot,
    bool clearUploadingSlot = false,
    bool? isSubmitting,
    AppException? error,
    bool clearError = false,
    SellerApplication? submitted,
  }) {
    return SellerOnboardingState(
      storeLat: storeLat ?? this.storeLat,
      storeLng: storeLng ?? this.storeLng,
      storeWebsite: storeWebsite ?? this.storeWebsite,
      storeInstagram: storeInstagram ?? this.storeInstagram,
      storeTelegram: storeTelegram ?? this.storeTelegram,
      storeWhatsapp: storeWhatsapp ?? this.storeWhatsapp,
      birthDate: birthDate ?? this.birthDate,
      passportFrontKey: passportFrontKey ?? this.passportFrontKey,
      passportBackKey: passportBackKey ?? this.passportBackKey,
      selfieWithPassportKey: selfieWithPassportKey ?? this.selfieWithPassportKey,
      selfieWithPassportLocalPath: selfieWithPassportLocalPath ?? this.selfieWithPassportLocalPath,
      liveSelfieKey: liveSelfieKey ?? this.liveSelfieKey,
      livenessPassed: livenessPassed ?? this.livenessPassed,
      faceMatchScore: faceMatchScore ?? this.faceMatchScore,
      isLocating: isLocating ?? this.isLocating,
      uploadingSlot: clearUploadingSlot ? null : (uploadingSlot ?? this.uploadingSlot),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      submitted: submitted ?? this.submitted,
    );
  }
}

class SellerOnboardingController extends Notifier<SellerOnboardingState> {
  @override
  SellerOnboardingState build() => const SellerOnboardingState();

  Future<void> useCurrentLocation() async {
    state = state.copyWith(isLocating: true, clearError: true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(isLocating: false, error: const NetworkException(NetworkErrorKind.unknown));
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        state = state.copyWith(isLocating: false, error: const NetworkException(NetworkErrorKind.unknown));
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      state = state.copyWith(isLocating: false, storeLat: position.latitude, storeLng: position.longitude);
    } catch (e) {
      state = state.copyWith(isLocating: false, error: ErrorMapper.map(e));
    }
  }

  void setSocialLinks({String? website, String? instagram, String? telegram, String? whatsapp}) {
    state = state.copyWith(
      storeWebsite: website,
      storeInstagram: instagram,
      storeTelegram: telegram,
      storeWhatsapp: whatsapp,
    );
  }

  void setBirthDate(DateTime date) {
    state = state.copyWith(birthDate: date);
  }

  Future<void> captureDocument(SellerDocumentSlot slot) async {
    state = state.copyWith(uploadingSlot: slot, clearError: true);
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 85);
      if (picked == null) {
        state = state.copyWith(clearUploadingSlot: true);
        return;
      }
      final bytes = await picked.readAsBytes();
      final key = await ref.read(uploadRepositoryProvider).uploadImage(bytes: bytes, purpose: 'seller-kyc');
      switch (slot) {
        case SellerDocumentSlot.passportFront:
          state = state.copyWith(passportFrontKey: key, clearUploadingSlot: true);
        case SellerDocumentSlot.passportBack:
          state = state.copyWith(passportBackKey: key, clearUploadingSlot: true);
        case SellerDocumentSlot.selfieWithPassport:
          state = state.copyWith(
            selfieWithPassportKey: key,
            selfieWithPassportLocalPath: picked.path,
            clearUploadingSlot: true,
          );
      }
    } catch (e) {
      state = state.copyWith(clearUploadingSlot: true, error: ErrorMapper.map(e));
    }
  }

  /// Called by the face-liveness screen once it has captured, analyzed and
  /// uploaded the live selfie itself (camera + ML Kit both need to live in
  /// that screen's State, not here — see its doc comment).
  void setLivenessResult({required String liveSelfieKey, required bool passed, double? score}) {
    state = state.copyWith(liveSelfieKey: liveSelfieKey, livenessPassed: passed, faceMatchScore: score);
  }

  Future<void> submit() async {
    if (state.birthDate == null || state.liveSelfieKey == null) return;
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final app = await ref.read(sellerApplicationRepositoryProvider).create(
            CreateSellerApplicationRequest(
              birthDate: _formatDate(state.birthDate!),
              storeLat: state.storeLat,
              storeLng: state.storeLng,
              storeWebsite: state.storeWebsite,
              storeInstagram: state.storeInstagram,
              storeTelegram: state.storeTelegram,
              storeWhatsapp: state.storeWhatsapp,
              passportFrontKey: state.passportFrontKey!,
              passportBackKey: state.passportBackKey!,
              selfieWithPassportKey: state.selfieWithPassportKey!,
              liveSelfieKey: state.liveSelfieKey!,
              livenessPassed: state.livenessPassed,
              faceMatchScore: state.faceMatchScore,
            ),
          );
      state = state.copyWith(isSubmitting: false, submitted: app);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: ErrorMapper.map(e));
    }
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

final sellerOnboardingControllerProvider =
    NotifierProvider<SellerOnboardingController, SellerOnboardingState>(SellerOnboardingController.new);

/// The caller's existing seller application, if any — used by the intro
/// screen to skip straight to the status screen instead of restarting the
/// wizard, and by the status screen itself.
final sellerMyApplicationProvider = FutureProvider<SellerApplication?>((ref) {
  return ref.watch(sellerApplicationRepositoryProvider).getMine();
});
