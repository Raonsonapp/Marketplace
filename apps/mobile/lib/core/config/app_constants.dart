/// App-wide constants that are not environment-dependent.
class AppConstants {
  AppConstants._();

  static const String appName = 'TajikShop';
  static const String currencyCode = 'TJS';

  /// Default page size for cursor-paginated list endpoints.
  static const int defaultPageSize = 20;

  /// OTP resend cooldown fallback (seconds) used until the server returns
  /// its own `retry_after_seconds` value.
  static const int defaultOtpCooldownSeconds = 60;

  /// OTP code length as defined in docs/SECURITY.md.
  static const int otpLength = 6;

  /// Tajikistan phone number prefix.
  static const String phoneCountryCode = '+992';

  /// Connect/receive timeouts for the HTTP client.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Secure-storage keys.
  static const String storageKeyAccessToken = 'auth_access_token';
  static const String storageKeyRefreshToken = 'auth_refresh_token';
  static const String storageKeyLanguage = 'app_language';

  static const List<String> supportedLocales = ['tg', 'ru'];
  static const String defaultLocale = 'tg';
}
