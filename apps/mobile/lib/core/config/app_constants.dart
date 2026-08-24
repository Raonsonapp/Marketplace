/// App-wide constants that are not environment-dependent.
class AppConstants {
  AppConstants._();

  static const String appName = 'YouShop';
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

  /// The Telegram bot OTP codes are delivered from (docs/SMS_PROVIDERS.md)
  /// — codes never arrive by SMS. Used for a direct "open the bot" link on
  /// the OTP screen, alongside the deep link the phone-entry screen gets
  /// from a TELEGRAM_NOT_LINKED error's details.
  static const String otpTelegramBotUsername = 'VerificationYouShopBot';

  /// Connect/receive timeouts for the HTTP client.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Secure-storage keys.
  static const String storageKeyAccessToken = 'auth_access_token';
  static const String storageKeyRefreshToken = 'auth_refresh_token';
  static const String storageKeyLanguage = 'app_language';

  static const List<String> supportedLocales = ['tg', 'ru', 'en'];
  static const String defaultLocale = 'tg';
}
