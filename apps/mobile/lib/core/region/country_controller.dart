import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/country.dart';
import '../storage/preferences_storage.dart';
import 'region_repository.dart';

/// The list of markets, fetched once and cached for the session. The app
/// must stay usable when this fails (no network on first launch), so every
/// consumer treats an error or empty list as "fall back to the built-in
/// Tajikistan defaults" rather than blocking.
final countriesProvider = FutureProvider<List<Country>>((ref) async {
  return ref.watch(regionRepositoryProvider).getCountries();
});

/// Which market the shopper is in. Drives the currency shown, the phone dial
/// code, which cities the address form offers, where the map opens, and the
/// `country` filter sent to `/home` and `/stores`.
///
/// Persisted locally so the choice survives a restart even before the
/// profile call comes back; `PATCH /profile` mirrors it to the server so it
/// follows the account to a new device.
class SelectedCountryController extends Notifier<String> {
  @override
  String build() {
    return ref.watch(preferencesStorageProvider).readCountry() ?? defaultCountryCode;
  }

  /// Tajikistan — the market the app launched in, and the value every
  /// pre-existing account carries on the server (migration 0007).
  static const String defaultCountryCode = 'TJ';

  Future<void> select(String code) async {
    final normalized = code.trim().toUpperCase();
    if (normalized.length != 2 || normalized == state) return;
    await ref.read(preferencesStorageProvider).saveCountry(normalized);
    state = normalized;
  }
}

const String defaultCountryCode = SelectedCountryController.defaultCountryCode;

final selectedCountryProvider =
    NotifierProvider<SelectedCountryController, String>(SelectedCountryController.new);

/// The full [Country] record for [selectedCountryProvider], or null while the
/// list is still loading (or if the server is unreachable). Callers that need
/// a currency label fall back to a plain amount rather than guessing.
final activeCountryProvider = Provider<Country?>((ref) {
  final code = ref.watch(selectedCountryProvider);
  final countries = ref.watch(countriesProvider).valueOrNull;
  if (countries == null || countries.isEmpty) return null;
  for (final c in countries) {
    if (c.code == code) return c;
  }
  return countries.first;
});
