import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/utils/email_validator.dart';
import '../data/auth_repository.dart';

part 'email_entry_controller.freezed.dart';

@freezed
abstract class EmailEntryState with _$EmailEntryState {
  const factory EmailEntryState({
    @Default('') String rawInput,
    @Default(false) bool isSubmitting,
    String? normalizedEmail,
    AppException? error,
    @Default(false) bool otpSent,
    @Default(0) int retryAfterSeconds,
    @Default(false) bool showFormatError,
  }) = _EmailEntryState;

  const EmailEntryState._();

  bool get isValid => EmailValidator.isValid(rawInput);
}

/// Drives the sign-in screen: validates the email address, then requests a
/// 6-digit code with `POST /auth/send-otp` (docs/API_SPEC.md). The code is
/// mailed to that address, which is also the account identifier — there is
/// no SMS/phone step (see docs/SMS_PROVIDERS.md for why delivery is by
/// email).
class EmailEntryController extends Notifier<EmailEntryState> {
  @override
  EmailEntryState build() => const EmailEntryState();

  void updateInput(String value) {
    state = state.copyWith(rawInput: value, showFormatError: false, error: null);
  }

  Future<void> submit() async {
    final normalized = EmailValidator.normalize(state.rawInput);
    if (normalized == null) {
      state = state.copyWith(showFormatError: true);
      return;
    }

    state = state.copyWith(
      isSubmitting: true,
      error: null,
      showFormatError: false,
      normalizedEmail: normalized,
    );

    try {
      final result = await ref.read(authRepositoryProvider).sendOtp(email: normalized);
      state = state.copyWith(
        isSubmitting: false,
        otpSent: true,
        retryAfterSeconds: result.retryAfterSeconds,
      );
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
    }
  }

  void resetOtpSentFlag() {
    state = state.copyWith(otpSent: false);
  }
}

final emailEntryControllerProvider =
    NotifierProvider<EmailEntryController, EmailEntryState>(EmailEntryController.new);
