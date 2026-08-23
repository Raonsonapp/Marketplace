/// Environment configuration for the TajikShop app.
///
/// The API base URL is supplied at build/run time via `--dart-define`, e.g.:
///
/// ```
/// flutter run --dart-define=API_BASE_URL=https://api.tajikshop.tj/api/v1
/// ```
///
/// When not provided, it defaults to the Android emulator's host-loopback
/// address pointing at a locally running backend (see docs/ARCHITECTURE.md).
class Env {
  Env._();

  /// Default target for the Android emulator (`10.0.2.2` maps to the host
  /// machine's `localhost`). Override with `--dart-define=API_BASE_URL=...`
  /// for physical devices, iOS simulator, or a deployed backend.
  static const String _defaultApiBaseUrl = 'http://10.0.2.2:8080/api/v1';

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultApiBaseUrl,
  );

  /// Whether verbose network/debug logging should be enabled. Defaults to
  /// the debug-mode assert flag but can be forced via `--dart-define`.
  static const bool verboseLogging = bool.fromEnvironment(
    'VERBOSE_LOGGING',
    defaultValue: false,
  );
}
