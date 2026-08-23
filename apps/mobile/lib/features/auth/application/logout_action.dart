import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_controller.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../data/auth_repository.dart';

/// Best-effort server-side logout (`POST /auth/logout`) followed by always
/// clearing the local session, regardless of whether the server call
/// succeeded (e.g. the refresh token may already be expired).
Future<void> performLogout(Ref ref) async {
  final refreshToken = await ref.read(secureTokenStorageProvider).readRefreshToken();
  if (refreshToken != null && refreshToken.isNotEmpty) {
    try {
      await ref.read(authRepositoryProvider).logout(refreshToken: refreshToken);
    } catch (_) {
      // Ignore — we still clear the local session below.
    }
  }
  await ref.read(sessionControllerProvider.notifier).logout();
}
