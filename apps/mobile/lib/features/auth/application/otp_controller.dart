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
class OtpState with _$OtpState {
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

/// Drives the OTP-entry screen for a given [phone]: code input, calling
/// `POST /auth/verify-otp`, the resend cooldown countdown, and reporting a
/// successful login to [SessionController] (see docs/API_SPEC.md,
/// docs/SECURITY.md).
class OtpController extends FamilyNotifier<OtpState, String> {
  Timer? _timer;

  @override
  OtpState build(String arg) {
    ref.onDispose(() => _timer?.cancel());
    _startCooldown(AppConstants.defaultOtpCooldownSeconds);
    return OtpState(phone: arg, cooldownSeconds: AppConstants.defaultOtpCooldownSeconds);
  }

  void updateCode(String value) {
    state = state.copyWith(code: value, error: null);
  }

  void _startCooldown(int seconds) {
    _timer?.cancel();
    state = state.copyWith(cooldownSeconds: seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.cooldownSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(cooldownSeconds: 0);
      } else {
        state = state.copyWith(cooldownSeconds: remaining);
      }
    });
  }

  Future<void> resend() async {
    if (state.cooldownSeconds > 0 || state.isResending) return;
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
      final tokens = await ref.read(authRepositoryProvider).verifyOtp(
            phone: state.phone,
            code: state.code,
          );
      final user = tokens.user ??
          AppUser(id: '', phone: state.phone);
      await ref.read(sessionControllerProvider.notifier).completeLogin(
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
            user: user,
          );
      state = state.copyWith(isVerifying: false, verified: true);
    } on AppException catch (e) {
      state = state.copyWith(isVerifying: false, error: e);
    }
  }
}

final otpControllerProvider =
    NotifierProvider.family<OtpController, OtpState, String>(OtpController.new);
