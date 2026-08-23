import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../storage/secure_token_storage.dart';
import 'session_state.dart';

/// Owns the app's authentication session: whether a user is logged in, and
/// their profile once known. Reads persisted tokens on startup so the
/// splash screen / router redirect guard can decide where to send the user.
///
/// This controller intentionally does not call any HTTP endpoint itself —
/// `features/auth` calls the auth repository and then reports the outcome
/// here via [completeLogin]/[logout]. [forceLogout] is called by the Dio
/// auth interceptor when a token refresh fails, so a session can expire from
/// deep inside the network layer without a circular feature dependency.
class SessionController extends AsyncNotifier<SessionState> {
  @override
  Future<SessionState> build() async {
    final storage = ref.watch(secureTokenStorageProvider);
    final refreshToken = await storage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return const SessionState(status: AuthStatus.unauthenticated);
    }
    return const SessionState(status: AuthStatus.authenticated);
  }

  Future<void> completeLogin({
    required String accessToken,
    required String refreshToken,
    required AppUser user,
  }) async {
    final storage = ref.read(secureTokenStorageProvider);
    await storage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    state = AsyncData(SessionState(status: AuthStatus.authenticated, user: user));
  }

  /// Called after the feature layer has (best-effort) told the server the
  /// session ended. Always clears local state regardless of server result.
  Future<void> logout() async {
    final storage = ref.read(secureTokenStorageProvider);
    await storage.clear();
    state = const AsyncData(SessionState(status: AuthStatus.unauthenticated));
  }

  /// Called by [AuthInterceptor] when a refresh-token attempt fails. Clears
  /// tokens and flips the app into the logged-out state; the router guard
  /// then redirects to login.
  void forceLogout() {
    // Fire-and-forget: the token storage clear can finish after the state
    // flip below — nothing awaits this method's completion.
    ref.read(secureTokenStorageProvider).clear();
    state = const AsyncData(SessionState(status: AuthStatus.unauthenticated));
  }

  void updateUser(AppUser user) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(user: user));
  }
}

final sessionControllerProvider =
    AsyncNotifierProvider<SessionController, SessionState>(SessionController.new);
