import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/fallback_localizations_delegate.dart';
import 'core/localization/locale_controller.dart';
import 'core/router/app_router.dart';
import 'core/storage/preferences_storage.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter's default ErrorWidget.builder shows full exception details only
  // in debug mode — a release build (like every APK this project ships to
  // testers so far) renders a bare gray box with no text at all for any
  // build-time error, which is indistinguishable from the app being frozen.
  // Show the real error unconditionally for now (pre-launch internal
  // testing only) so a screenshot of a "blank screen" actually carries the
  // information needed to fix it.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${details.exceptionAsString()}\n\n${details.stack}',
            style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontFamily: 'monospace'),
          ),
        ),
      ),
    );
  };

  final sharedPreferences = await SharedPreferences.getInstance();

  // Firebase Phone Auth (docs/FIREBASE_SETUP.md) is optional infrastructure:
  // `firebase_options.dart` ships as an obviously-placeholder config until
  // someone runs the real `flutterfire configure`. `Firebase.initializeApp`
  // does NOT validate the API key over the network — it happily "succeeds"
  // with garbage values, registering the app in `Firebase.apps` — so the
  // phone-entry screen's "use Firebase only if Firebase.apps is non-empty"
  // check would wrongly try real Firebase Phone Auth and fail at the actual
  // SMS-send call with an opaque "API key not valid" error. Guard against
  // that by never even calling initializeApp while the config is still the
  // known placeholder; once `flutterfire configure` writes real values,
  // this check naturally stops matching and Firebase Phone Auth activates
  // automatically, no other code change required.
  final isPlaceholderFirebaseConfig =
      DefaultFirebaseOptions.android.apiKey == 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE';
  if (!isPlaceholderFirebaseConfig) {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Firebase.initializeApp failed: $error');
      }
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'main',
        context: ErrorDescription('while initializing Firebase (optional; falls back to console-OTP)'),
        silent: true,
      ));
    }
  } else if (kDebugMode) {
    debugPrint('Firebase not configured yet (see docs/FIREBASE_SETUP.md) — '
        'using the console-OTP/Telegram Gateway login flow.');
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const YouShopApp(),
    ),
  );
}

class YouShopApp extends ConsumerWidget {
  const YouShopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Dark is the brand's primary/default look (docs/ARCHITECTURE.md); a
      // light variant exists and is ready to be exposed via a settings
      // toggle in a later phase.
      themeMode: ThemeMode.dark,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        // Flutter's own Material/Cupertino/Widgets localizations don't
        // ship a Tajik translation upstream — these fill that gap for
        // framework-chrome strings only (see the delegate docs).
        FallbackMaterialLocalizationsDelegate(),
        FallbackCupertinoLocalizationsDelegate(),
        FallbackWidgetsLocalizationsDelegate(),
      ],
      routerConfig: router,
    );
  }
}
