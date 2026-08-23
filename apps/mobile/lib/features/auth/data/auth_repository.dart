import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'auth_models.dart';

/// Talks to the `/auth/*` endpoints (see docs/API_SPEC.md). Holds no state
/// of its own — session state lives in `SessionController`.
class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<SendOtpResult> sendOtp({required String phone}) async {
    final json = await _client.post('/auth/send-otp', data: {'phone': phone});
    return SendOtpResult.fromJson(json);
  }

  Future<AuthTokens> verifyOtp({required String phone, required String code}) async {
    final json = await _client.post('/auth/verify-otp', data: {
      'phone': phone,
      'code': code,
    });
    return AuthTokens.fromJson(json);
  }

  /// `POST /auth/firebase-verify` — the real-SMS registration path (see
  /// docs/FIREBASE_SETUP.md, docs/SECURITY.md). [idToken] comes from
  /// `FirebaseAuth.signInWithCredential(...).user.getIdToken()` after the
  /// user enters the code Firebase texted them; the backend verifies it
  /// with Google and returns the same shape as [verifyOtp].
  Future<AuthTokens> verifyFirebaseToken({
    required String idToken,
    String? fullName,
  }) async {
    final json = await _client.post('/auth/firebase-verify', data: {
      'id_token': idToken,
      'full_name': ?fullName,
    });
    return AuthTokens.fromJson(json);
  }

  Future<AuthTokens> refresh({required String refreshToken}) async {
    final json = await _client.post('/auth/refresh', data: {'refresh_token': refreshToken});
    return AuthTokens.fromJson(json);
  }

  /// Best-effort server-side session invalidation. Callers should clear the
  /// local session regardless of whether this succeeds.
  Future<void> logout({required String refreshToken}) async {
    await _client.post('/auth/logout', data: {'refresh_token': refreshToken});
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});
