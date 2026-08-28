import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/country.dart';
import '../network/api_client.dart';

/// Calls `GET /countries` — the reference data that makes the app work in
/// both Tajikistan and Russia. The response inlines each country's cities,
/// so one request populates every picker in the app.
class RegionRepository {
  RegionRepository(this._client);

  final ApiClient _client;

  Future<List<Country>> getCountries() async {
    final json = await _client.get('/countries');
    final list = (json['data'] as List<dynamic>?) ?? const [];
    return list.map((e) => Country.fromJson(e as Map<String, dynamic>)).toList();
  }
}

final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  return RegionRepository(ref.watch(apiClientProvider));
});
