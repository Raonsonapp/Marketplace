import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_user.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/utils/phone_validator.dart';
import '../data/auth_repository.dart';

part 'phone_entry_controller.freezed.dart';

@freezed
abstract class PhoneEntryState with _$PhoneEntryState {
  const factory PhoneEntryState({
    @Default('') String rawInput,
    @Default(PhoneRegion.tajikistan) PhoneRegion region,
    @Default(false) bool isSubmitting,
    String? normalizedPhone,
    AppException? error,
    @Default(false) bool otpSent,
    @Default(0) int retryAfterSeconds,
    @Default(false) bool showFormatError,
    /// Set once Firebase's `codeSent` callback fires — carries it forward
    /// to the OTP screen so verification finishes against Firebase rather
    /// than the console-OTP endpoint (docs/FIREBASE_SETUP.md).
    String? firebaseVerificationId,
    /// True when Firebase auto-verified the code on-device
    /// (`verificationCompleted`, Android SMS auto-retrieval) and login
    /// already completed — the screen should skip the OTP screen entirely.
    @Default(false) bool autoVerifiedAndLoggedIn,
  }) = _PhoneEntryState;

  const PhoneEntryState._();

  bool get isValid => PhoneValidator.isValid(rawInput, region: region);
}

/// Drives the phone-entry screen: validates the +992 number, then either
///
/// - drives Firebase Phone Auth's `verifyPhoneNumber` (real SMS —
///   docs/FIREBASE_SETUP.md) when Firebase has been configured
///   (`Firebase.apps` non-empty), or
/// - falls back to the console-OTP `POST /auth/send-otp` (docs/API_SPEC.md)
///   otherwise, so the app is fully usable before Firebase is set up.
class PhoneEntryController extends Notifier<PhoneEntryState> {
  @override
  PhoneEntryState build() => const PhoneEntryState();

  void updateInput(String value) {
    // Auto-switch the region if the user pastes/types a number carrying its
    // own explicit country-code prefix (e.g. pasting a +7 number while the
    // Tajikistan tab is selected) — the selector then reflects reality
    // instead of silently disagreeing with what's on screen.
    final detected = PhoneValidator.detectRegion(value);
    state = PhoneEntryState(rawInput: value, region: detected ?? state.region);
  }

  void setRegion(PhoneRegion region) {
    state = state.copyWith(region: region, showFormatError: false);
  }

  bool get _firebaseConfigured => Firebase.apps.isNotEmpty;

  Future<void> submit() async {
    final normalized = PhoneValidator.normalize(state.rawInput, region: state.region);
    if (normalized == null) {
      state = state.copyWith(showFormatError: true);
      return;
    }

    state = state.copyWith(
      isSubmitting: true,
      error: null,
      showFormatError: false,
      normalizedPhone: normalized,
    );

    if (_firebaseConfigured) {
      await _submitViaFirebase(normalized);
    } else {
      await _submitViaConsoleOtp(normalized);
    }
  }

  Future<void> _submitViaConsoleOtp(String normalized) async {
    try {
      final result = await ref.read(authRepositoryProvider).sendOtp(phone: normalized);
      state = state.copyWith(
        isSubmitting: false,
        otpSent: true,
        retryAfterSeconds: result.retryAfterSeconds,
      );
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
    }
  }

  Future<void> _submitViaFirebase(String normalized) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: normalized,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android SMS auto-retrieval: Firebase already has a full
          // credential, no manual code entry needed — sign in right away.
          try {
            await _completeFirebaseSignIn(credential);
            state = state.copyWith(isSubmitting: false, autoVerifiedAndLoggedIn: true);
          } on FirebaseAuthException catch (e) {
            state = state.copyWith(
              isSubmitting: false,
              error: FirebaseAuthAppException(e.code, e.message),
            );
          } on AppException catch (e) {
            state = state.copyWith(isSubmitting: false, error: e);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          state = state.copyWith(
            isSubmitting: false,
            error: FirebaseAuthAppException(e.code, e.message),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          state = state.copyWith(
            isSubmitting: false,
            otpSent: true,
            firebaseVerificationId: verificationId,
            retryAfterSeconds: 60,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // No-op: the user can still enter the code manually using the
          // same verificationId, already stored above from `codeSent`.
        },
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: FirebaseAuthAppException(e.code, e.message),
      );
    }
  }

  Future<void> _completeFirebaseSignIn(PhoneAuthCredential credential) async {
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final idToken = await userCredential.user?.getIdToken();
    if (idToken == null) {
      throw const UnknownException('Firebase sign-in returned no ID token');
    }
    final tokens = await ref.read(authRepositoryProvider).verifyFirebaseToken(idToken: idToken);
    final user = tokens.user ?? AppUser(id: '', phone: userCredential.user?.phoneNumber ?? '');
    await ref.read(sessionControllerProvider.notifier).completeLogin(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
          user: user,
        );
  }

  void resetOtpSentFlag() {
    state = state.copyWith(otpSent: false);
  }
}

final phoneEntryControllerProvider =
    NotifierProvider<PhoneEntryController, PhoneEntryState>(PhoneEntryController.new);
