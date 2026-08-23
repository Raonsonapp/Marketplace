/// Base type for every exception that can surface from the network/data
/// layer up to the UI. UI code should catch this (not raw [DioException])
/// and use [ErrorStateView] to render a localized, retryable error.
sealed class AppException implements Exception {
  const AppException();
}

/// A well-formed error response from the API, matching docs/API_SPEC.md's
/// error envelope: `{ "error": { "code", "message", "details" } }`.
///
/// [message] is already localized server-side based on `Accept-Language`,
/// so it can be shown to the user as-is. [code] is the stable machine
/// key (`OUT_OF_STOCK`, `INVALID_OTP`, etc.) for client-side branching.
final class ApiException extends AppException {
  const ApiException({
    required this.code,
    required this.message,
    this.details = const {},
    this.statusCode,
  });

  final String code;
  final String message;
  final Map<String, dynamic> details;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}

/// The kind of connectivity failure behind a [NetworkException] — the UI
/// picks the right localized string per kind (see `app_ru.arb`/`app_tg.arb`).
enum NetworkErrorKind { timeout, noConnection, cancelled, unknown }

/// Transport-level failure (timeout, no connection, DNS, etc.) — never a
/// parsed server response. Carries no pre-localized message; the UI maps
/// [kind] to a localized string via `AppLocalizations`.
final class NetworkException extends AppException {
  const NetworkException(this.kind);

  final NetworkErrorKind kind;

  @override
  String toString() => 'NetworkException(kind: $kind)';
}

/// Anything else unexpected (malformed response, programmer error surfaced
/// through the repository layer, etc.).
final class UnknownException extends AppException {
  const UnknownException(this.originalMessage);

  final String originalMessage;

  @override
  String toString() => 'UnknownException($originalMessage)';
}
