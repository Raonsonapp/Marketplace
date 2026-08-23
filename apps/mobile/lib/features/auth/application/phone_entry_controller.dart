import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/utils/phone_validator.dart';
import '../data/auth_repository.dart';

part 'phone_entry_controller.freezed.dart';

@freezed
class PhoneEntryState with _$PhoneEntryState {
  const factory PhoneEntryState({
    @Default('') String rawInput,
    @Default(false) bool isSubmitting,
    String? normalizedPhone,
    AppException? error,
    @Default(false) bool otpSent,
    @Default(0) int retryAfterSeconds,
    @Default(false) bool showFormatError,
  }) = _PhoneEntryState;

  const PhoneEntryState._();

  bool get isValid => PhoneValidator.isValid(rawInput);
}

/// Drives the phone-entry screen: validates the +992 number, and calls
/// `POST /auth/send-otp` (see docs/API_SPEC.md). On success, exposes
/// [PhoneEntryState.otpSent] so the screen can navigate to OTP entry.
class PhoneEntryController extends Notifier<PhoneEntryState> {
  @override
  PhoneEntryState build() => const PhoneEntryState();

  void updateInput(String value) {
    state = PhoneEntryState(rawInput: value);
  }

  Future<void> submit() async {
    final normalized = PhoneValidator.normalize(state.rawInput);
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

  void resetOtpSentFlag() {
    state = state.copyWith(otpSent: false);
  }
}

final phoneEntryControllerProvider =
    NotifierProvider<PhoneEntryController, PhoneEntryState>(PhoneEntryController.new);
