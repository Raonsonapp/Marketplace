import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_constants.dart';
import '../config/env.dart';
import 'auth_interceptor.dart';

/// The single [Dio] instance used by every repository. Configured with the
/// base URL from [Env], sane timeouts, and [AuthInterceptor] for bearer
/// tokens + one-shot refresh-on-401 (see docs/SECURITY.md).
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: AppConstants.connectTimeout,
    receiveTimeout: AppConstants.receiveTimeout,
    contentType: 'application/json',
    headers: const {'Accept-Language': 'tg'},
  ));

  dio.interceptors.add(AuthInterceptor(ref, ref.watch(refreshDioProvider)));

  if (kDebugMode && Env.verboseLogging) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  return dio;
});

/// Updates the `Accept-Language` header used for server-localized error
/// messages when the user switches app language. Called by the locale
/// controller.
void updateAcceptLanguage(Dio dio, String languageCode) {
  dio.options.headers['Accept-Language'] = languageCode;
}
