import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/preferences_storage.dart';

/// Owns the active app theme mode (dark by default — the brand's primary
/// look, docs/ARCHITECTURE.md — with light and "follow system" both
/// available). Persists the choice locally, mirroring LocaleController.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final stored = ref.watch(preferencesStorageProvider).readThemeMode();
    return switch (stored) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      ThemeMode.dark => 'dark',
    };
    await ref.read(preferencesStorageProvider).saveThemeMode(value);
    state = mode;
  }
}

final themeModeControllerProvider = NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
