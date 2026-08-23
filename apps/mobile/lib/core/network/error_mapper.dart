import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Maps any error thrown by [Dio] into a typed [AppException] the rest of
/// the app knows how to render (see docs/API_SPEC.md error envelope and
/// docs/SECURITY.md token-refresh flow).
class ErrorMapper {
  ErrorMapper._();

  static AppException map(Object error) {
    if (error is AppException) return error;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkException(NetworkErrorKind.timeout);
        case DioExceptionType.connectionError:
          return const NetworkException(NetworkErrorKind.noConnection);
        case DioExceptionType.cancel:
          return const NetworkException(NetworkErrorKind.cancelled);
        case DioExceptionType.badResponse:
          return _mapBadResponse(error);
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
        default:
          return const NetworkException(NetworkErrorKind.unknown);
      }
    }

    return UnknownException(error.toString());
  }

  static AppException _mapBadResponse(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (data is Map<String, dynamic> && data['error'] is Map) {
      final errorBody = data['error'] as Map<String, dynamic>;
      return ApiException(
        code: (errorBody['code'] as String?) ?? 'UNKNOWN_ERROR',
        message: (errorBody['message'] as String?) ?? 'Хатогии номаълум рӯй дод',
        details: (errorBody['details'] as Map?)?.cast<String, dynamic>() ?? const {},
        statusCode: statusCode,
      );
    }

    return ApiException(
      code: 'HTTP_$statusCode',
      message: 'Хатогии сервер: $statusCode',
      statusCode: statusCode,
    );
  }
}
