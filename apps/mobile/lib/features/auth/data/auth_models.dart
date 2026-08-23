import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/app_user.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// `POST /auth/send-otp` response (see docs/API_SPEC.md).
@freezed
abstract class SendOtpResult with _$SendOtpResult {
  const factory SendOtpResult({required int retryAfterSeconds}) = _SendOtpResult;

  factory SendOtpResult.fromJson(Map<String, dynamic> json) => _$SendOtpResultFromJson(json);
}

/// `POST /auth/verify-otp` / `POST /auth/refresh` response payload.
@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
    AppUser? user,
    @Default(false) bool isNewUser,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);
}
