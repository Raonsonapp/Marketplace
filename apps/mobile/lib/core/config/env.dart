/// Environment configuration for the YouShop app.
///
/// The API base URL is supplied at build/run time via `--dart-define`, e.g.:
///
/// ```
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1
/// ```
///
/// When not provided, it defaults to the live hosted backend (see
/// docs/HUGGINGFACE_DEPLOYMENT.md) so a release APK/AAB built without any
/// extra flags — e.g. straight out of the CI release workflow, installed on
/// a physical device — works out of the box. Override with
/// `--dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1` for local
/// backend development against the Android emulator.
class Env {
  Env._();

  /// The live TajikShop/YouShop API on Hugging Face Spaces (§6,
  /// docs/HUGGINGFACE_DEPLOYMENT.md). Override with
  /// `--dart-define=API_BASE_URL=...` for local dev or a different backend.
  static const String _defaultApiBaseUrl =
      'https://mahmadmurodov-youshop.hf.space/api/v1';

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultApiBaseUrl,
  );

  /// Base URL for `WS /ws/...` connections. Those routes are mounted at the
  /// Gin engine's root (`internal/httpserver/router.go`), not under the
  /// REST API's own `/api/v1` prefix like everything else — so this is the
  /// bare origin (scheme+host+port) with ws(s) swapped in, not [apiBaseUrl]
  /// with a suffix stripped off.
  static String get wsBaseUrl {
    final origin = Uri.parse(apiBaseUrl).origin;
    return origin.replaceFirst(RegExp('^http'), 'ws');
  }

  /// Whether verbose network/debug logging should be enabled. Defaults to
  /// the debug-mode assert flag but can be forced via `--dart-define`.
  static const bool verboseLogging = bool.fromEnvironment(
    'VERBOSE_LOGGING',
    defaultValue: false,
  );
}
