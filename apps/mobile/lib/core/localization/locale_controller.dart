import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_constants.dart';
import '../network/dio_client.dart';
import '../storage/preferences_storage.dart';

/// Owns the active app language (Tajik by default, Russian as secondary —
/// see docs/ARCHITECTURE.md). Persists the choice locally and keeps the
/// Dio `Accept-Language` header in sync so server-localized error messages
/// (docs/API_SPEC.md) match the UI language.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    final stored = ref.watch(preferencesStorageProvider).readLanguage();
    final languageCode = AppConstants.supportedLocales.contains(stored)
        ? stored!
        : AppConstants.defaultLocale;
    updateAcceptLanguage(ref.read(dioProvider), languageCode);
    return Locale(languageCode);
  }

  Future<void> setLanguage(String languageCode) async {
    if (!AppConstants.supportedLocales.contains(languageCode)) return;
    await ref.read(preferencesStorageProvider).saveLanguage(languageCode);
    updateAcceptLanguage(ref.read(dioProvider), languageCode);
    state = Locale(languageCode);
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(LocaleController.new);
