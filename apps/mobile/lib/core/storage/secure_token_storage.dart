import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_constants.dart';

/// Wraps [FlutterSecureStorage] for the two secrets the app ever persists:
/// the short-lived access token and the rotating refresh token (see
/// docs/SECURITY.md). Never stores anything else here (no PII, no passwords
/// — there are none).
class SecureTokenStorage {
  SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> readAccessToken() =>
      _storage.read(key: AppConstants.storageKeyAccessToken);

  Future<String?> readRefreshToken() =>
      _storage.read(key: AppConstants.storageKeyRefreshToken);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(
      key: AppConstants.storageKeyAccessToken,
      value: accessToken,
    );
    await _storage.write(
      key: AppConstants.storageKeyRefreshToken,
      value: refreshToken,
    );
  }

  Future<void> clear() async {
    await _storage.delete(key: AppConstants.storageKeyAccessToken);
    await _storage.delete(key: AppConstants.storageKeyRefreshToken);
  }
}

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  // Default AndroidOptions already use strong AES-GCM + RSA-OAEP key
  // wrapping (flutter_secure_storage >= 10) with no extra flags needed.
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );
});

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage(ref.watch(secureStorageProvider));
});
