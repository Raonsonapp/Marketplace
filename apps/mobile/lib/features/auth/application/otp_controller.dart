import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/models/app_user.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/session/session_controller.dart';
import '../data/auth_repository.dart';

part 'otp_controller.freezed.dart';

@freezed
abstract class OtpState with _$OtpState {
  const factory OtpState({
    required String email,
    @Default('') String code,
    @Default(false) bool isVerifying,
    @Default(false) bool isResending,
    @Default(0) int cooldownSeconds,
    AppException? error,
    @Default(false) bool verified,
    @Default(false) bool isNewUser,
  }) = _OtpState;
}

/// Drives the OTP-entry screen for one email address: code input, the
/// resend cooldown countdown, and completing login via
/// `POST /auth/verify-otp` (docs/API_SPEC.md, docs/SECURITY.md). The family
/// key is the address the code was mailed to.
class OtpController extends FamilyNotifier<OtpState, String> {
  Timer? _timer;

  @override
  OtpState build(String arg) {
    ref.onDispose(() => _timer?.cancel());
    // Must not call _startCooldown here: it reads `state` (via copyWith) to
    // arm the timer, but Riverpod's `state` getter throws "Tried to read
    // the state of an uninitialized provider" until build() has actually
    // returned a value — this was a 100%-reproducible crash on every visit
    // to the OTP screen. Set the initial cooldown directly in the returned
    // OtpState instead; _timer only ever reads `state` from its callback,
    // which never fires until after build() has returned.
    _timer = Timer.periodic(const Duration(seconds: 1), _onCooldownTick);
    return OtpState(email: arg, cooldownSeconds: AppConstants.defaultOtpCooldownSeconds);
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
    state = state.copyWith(isResending: true, error: null);
    try {
      final result = await ref.read(authRepositoryProvider).sendOtp(email: state.email);
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
      final tokens = await ref.read(authRepositoryProvider).verifyOtp(
            email: state.email,
            code: state.code,
          );
      final user = tokens.user ?? AppUser(id: '', phone: '', email: state.email);
      await ref.read(sessionControllerProvider.notifier).completeLogin(
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
            user: user,
          );
      state = state.copyWith(isVerifying: false, verified: true, isNewUser: tokens.isNewUser);
    } on AppException catch (e) {
      state = state.copyWith(isVerifying: false, error: e);
    }
  }
}

final otpControllerProvider =
    NotifierProvider.family<OtpController, OtpState, String>(OtpController.new);
