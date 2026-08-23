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
  final sharedPreferences = await SharedPreferences.getInstance();

  // Firebase Phone Auth (docs/FIREBASE_SETUP.md) is optional infrastructure:
  // `firebase_options.dart` ships as an obviously-placeholder config until
  // someone runs the real `flutterfire configure`, so this call is expected
  // to fail until then. When it does, the app must keep working — the
  // phone-entry screen falls back to the console-OTP flow
  // (`send-otp`/`verify-otp`) whenever `Firebase.apps` is empty.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('Firebase.initializeApp failed (expected until '
          'docs/FIREBASE_SETUP.md is completed): $error');
    }
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'main',
      context: ErrorDescription('while initializing Firebase (optional; falls back to console-OTP)'),
      silent: true,
    ));
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const TajikShopApp(),
    ),
  );
}

class TajikShopApp extends ConsumerWidget {
  const TajikShopApp({super.key});

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
