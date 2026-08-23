import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_constants.dart';
import '../config/env.dart';
import '../session/session_controller.dart';
import '../storage/secure_token_storage.dart';

/// Attaches the bearer access token to every request and, on a 401, makes a
/// single attempt to refresh the session (via `POST /auth/refresh`) before
/// retrying the original request once. If the refresh itself fails, the
/// session is force-logged-out (see `SessionController.forceLogout`) and the
/// original 401 is propagated so the caller's error state still fires.
///
/// See docs/SECURITY.md: rotating refresh token, one refresh per 401, no
/// infinite retry loops.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref, this._refreshDio);

  final Ref _ref;
  final Dio _refreshDio;

  /// Guards against multiple concurrent requests each independently trying
  /// to refresh the same expired token — only one refresh call is ever
  /// in flight at a time; the rest await it.
  Future<String?>? _refreshInFlight;

  SecureTokenStorage get _tokenStorage => _ref.read(secureTokenStorageProvider);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains('/auth/refresh');

    if (!isUnauthorized || isRefreshCall) {
      handler.next(err);
      return;
    }

    final newAccessToken = await _refreshAccessToken();
    if (newAccessToken == null) {
      _ref.read(sessionControllerProvider.notifier).forceLogout();
      handler.next(err);
      return;
    }

    try {
      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final response = await _refreshDio.fetch(retryOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _refreshAccessToken() {
    return _refreshInFlight ??= _doRefresh().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<String?> _doRefresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final data = response.data;
      if (data == null) return null;
      final newAccessToken = data['access_token'] as String?;
      final newRefreshToken = data['refresh_token'] as String?;
      if (newAccessToken == null || newRefreshToken == null) return null;

      await _tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
      return newAccessToken;
    } on DioException {
      return null;
    }
  }
}

/// A bare Dio instance with no interceptors, used exclusively for the
/// refresh-token call and its retry so it never recurses back into
/// [AuthInterceptor].
final refreshDioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: AppConstants.connectTimeout,
    receiveTimeout: AppConstants.receiveTimeout,
    contentType: 'application/json',
  ));
});
