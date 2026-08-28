import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/fallback_localizations_delegate.dart';
import 'core/localization/locale_controller.dart';
import 'core/region/country_controller.dart';
import 'core/region/currency_scope.dart';
import 'core/router/app_router.dart';
import 'core/storage/preferences_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter's default ErrorWidget.builder renders a bare gray box with no
  // text in a release build, which is indistinguishable from the app being
  // frozen. During internal testing we dumped the raw exception and stack
  // on screen instead, but a Play-store build must not: a stack trace is
  // meaningless to a shopper and leaks internal structure. So show the real
  // error only in debug/profile builds, and a plain apology in release.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kReleaseMode) {
      return const Material(
        color: Colors.black,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'YouShop',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ),
      );
    }
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
    final themeMode = ref.watch(themeModeControllerProvider);
    // Prices arrive from the API without a currency; the active market
    // decides whether they read as somoni or rubles. Published once here so
    // every price widget can read it from its BuildContext.
    final currencyLabel = ref.watch(activeCountryProvider)?.currencyLabel(locale.languageCode);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Dark is the brand's primary/default look (docs/ARCHITECTURE.md);
      // the user can switch to light or "follow system" in Settings
      // (core/theme/theme_controller.dart).
      themeMode: themeMode,
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
      builder: (context, child) =>
          CurrencyScope(label: currencyLabel, child: child ?? const SizedBox.shrink()),
    );
  }
}
