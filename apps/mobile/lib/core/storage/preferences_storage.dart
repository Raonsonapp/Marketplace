import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_constants.dart';

/// Lightweight non-secret local preferences (language choice, recent
/// searches). Backed by [SharedPreferences].
class PreferencesStorage {
  PreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 10;
  static const String _onboardingSeenKey = 'onboarding_seen';

  String? readLanguage() => _prefs.getString(AppConstants.storageKeyLanguage);

  Future<void> saveLanguage(String languageCode) =>
      _prefs.setString(AppConstants.storageKeyLanguage, languageCode);

  List<String> readRecentSearches() =>
      _prefs.getStringList(_recentSearchesKey) ?? const [];

  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final current = readRecentSearches().where((e) => e.toLowerCase() != trimmed.toLowerCase()).toList();
    current.insert(0, trimmed);
    final capped = current.take(_maxRecentSearches).toList();
    await _prefs.setStringList(_recentSearchesKey, capped);
  }

  Future<void> clearRecentSearches() => _prefs.remove(_recentSearchesKey);

  bool hasSeenOnboarding() => _prefs.getBool(_onboardingSeenKey) ?? false;

  Future<void> setOnboardingSeen() => _prefs.setBool(_onboardingSeenKey, true);
}

/// Overridden in `main.dart` with the awaited [SharedPreferences] instance
/// before the app is run.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

final preferencesStorageProvider = Provider<PreferencesStorage>((ref) {
  return PreferencesStorage(ref.watch(sharedPreferencesProvider));
});
