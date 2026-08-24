import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/models/app_user.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/session/session_controller.dart';
import '../data/auth_repository.dart';

part 'otp_controller.freezed.dart';

/// Identifies one OTP-entry session: the phone number, plus — when the
/// phone-entry screen went through Firebase Phone Auth rather than the
/// console-OTP fallback — the `verificationId` Firebase handed back from
/// `codeSent` (docs/FIREBASE_SETUP.md). Records get structural equality for
/// free, which is exactly what a Riverpod family key needs.
typedef OtpSessionKey = ({String phone, String? firebaseVerificationId});

@freezed
abstract class OtpState with _$OtpState {
  const factory OtpState({
    required String phone,
    @Default('') String code,
    @Default(false) bool isVerifying,
    @Default(false) bool isResending,
    @Default(0) int cooldownSeconds,
    AppException? error,
    @Default(false) bool verified,
  }) = _OtpState;
}

/// Drives the OTP-entry screen for one [OtpSessionKey]: code input, the
/// resend cooldown countdown, and completing login — via
/// `POST /auth/verify-otp` for the console-OTP path, or
/// `FirebaseAuth.signInWithCredential` + `POST /auth/firebase-verify` for
/// the real-SMS path (docs/API_SPEC.md, docs/FIREBASE_SETUP.md,
/// docs/SECURITY.md).
class OtpController extends FamilyNotifier<OtpState, OtpSessionKey> {
  Timer? _timer;

  bool get _isFirebaseFlow => arg.firebaseVerificationId != null;

  @override
  OtpState build(OtpSessionKey arg) {
    ref.onDispose(() => _timer?.cancel());
    // Must not call _startCooldown here: it reads `state` (via copyWith) to
    // arm the timer, but Riverpod's `state` getter throws "Tried to read
    // the state of an uninitialized provider" until build() has actually
    // returned a value — this was a 100%-reproducible crash on every visit
    // to the OTP screen. Set the initial cooldown directly in the returned
    // OtpState instead; _timer only ever reads `state` from its callback,
    // which never fires until after build() has returned.
    _timer = Timer.periodic(const Duration(seconds: 1), _onCooldownTick);
    return OtpState(phone: arg.phone, cooldownSeconds: AppConstants.defaultOtpCooldownSeconds);
  }

  void updateCode(String value) {
    state = state.copyWith(code: value, error: null);
  }

  void _onCooldownTick(Timer timer) {
    final remaining = state.cooldownSeconds - 1;
    if (remaining <= 0) {
      timer.cancel();
      state = state.copyWith(cooldownSeconds: 0);
    } else {
      state = state.copyWith(cooldownSeconds: remaining);
    }
  }

  void _startCooldown(int seconds) {
    _timer?.cancel();
    state = state.copyWith(cooldownSeconds: seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), _onCooldownTick);
  }

  Future<void> resend() async {
    if (state.cooldownSeconds > 0 || state.isResending) return;
    if (_isFirebaseFlow) {
      // Firebase manages its own resend via a fresh `verifyPhoneNumber`
      // call from the phone-entry screen; there is nothing to resend from
      // here without a new verificationId, so just re-arm the cooldown UI.
      // (The user can go back and resubmit their number if truly stuck.)
      _startCooldown(AppConstants.defaultOtpCooldownSeconds);
      return;
    }
    state = state.copyWith(isResending: true, error: null);
    try {
      final result = await ref.read(authRepositoryProvider).sendOtp(phone: state.phone);
      state = state.copyWith(isResending: false);
      _startCooldown(result.retryAfterSeconds);
    } on AppException catch (e) {
      state = state.copyWith(isResending: false, error: e);
    }
  }

  Future<void> verify() async {
    if (state.code.length != AppConstants.otpLength) return;
    state = state.copyWith(isVerifying: true, error: null);
    try {
      if (_isFirebaseFlow) {
        await _verifyViaFirebase();
      } else {
        await _verifyViaConsoleOtp();
      }
      state = state.copyWith(isVerifying: false, verified: true);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isVerifying: false,
        error: FirebaseAuthAppException(e.code, e.message),
      );
    } on AppException catch (e) {
      state = state.copyWith(isVerifying: false, error: e);
    }
  }

  Future<void> _verifyViaConsoleOtp() async {
    final tokens = await ref.read(authRepositoryProvider).verifyOtp(
          phone: state.phone,
          code: state.code,
        );
    final user = tokens.user ?? AppUser(id: '', phone: state.phone);
    await ref.read(sessionControllerProvider.notifier).completeLogin(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
          user: user,
        );
  }

  Future<void> _verifyViaFirebase() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: arg.firebaseVerificationId!,
      smsCode: state.code,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final idToken = await userCredential.user?.getIdToken();
    if (idToken == null) {
      throw const UnknownException('Firebase sign-in returned no ID token');
    }
    final tokens = await ref.read(authRepositoryProvider).verifyFirebaseToken(idToken: idToken);
    final user = tokens.user ?? AppUser(id: '', phone: state.phone);
    await ref.read(sessionControllerProvider.notifier).completeLogin(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
          user: user,
        );
  }
}

final otpControllerProvider =
    NotifierProvider.family<OtpController, OtpState, OtpSessionKey>(OtpController.new);
