import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Flutter's own framework-chrome localizations (`MaterialLocalizations`,
/// `CupertinoLocalizations`, `WidgetsLocalizations` — back-button tooltips,
/// default date-picker headers, "OK"/"Cancel" on framework dialogs, etc.)
/// do not ship a Tajik (`tg`) translation upstream; only `ru` and other
/// major languages are bundled with `flutter_localizations`.
///
/// Every user-facing string in this app comes from our own
/// [AppLocalizations] (tj/ru ARB files), so this only affects a handful of
/// rarely-seen framework internals. Rather than crash (Flutter's
/// `Localizations` widget requires every delegate to resolve the active
/// locale) or silently fall back to English, these delegates claim support
/// for `tg` and serve the fully-translated Russian implementation for it —
/// the closest already-localized language for this audience — while
/// leaving `ru` itself untouched.
class FallbackMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationsDelegate();

  static const Locale _fallbackLocale = Locale('ru');

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'tg';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return GlobalMaterialLocalizations.delegate.load(_fallbackLocale);
  }

  @override
  bool shouldReload(FallbackMaterialLocalizationsDelegate old) => false;
}

class FallbackCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationsDelegate();

  static const Locale _fallbackLocale = Locale('ru');

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'tg';

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return GlobalCupertinoLocalizations.delegate.load(_fallbackLocale);
  }

  @override
  bool shouldReload(FallbackCupertinoLocalizationsDelegate old) => false;
}

class FallbackWidgetsLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  const FallbackWidgetsLocalizationsDelegate();

  static const Locale _fallbackLocale = Locale('ru');

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'tg';

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    return GlobalWidgetsLocalizations.delegate.load(_fallbackLocale);
  }

  @override
  bool shouldReload(FallbackWidgetsLocalizationsDelegate old) => false;
}
