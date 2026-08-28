import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/store.dart';
import '../../../core/network/api_client.dart';

/// Calls `GET /stores` and `GET /stores/:id` (docs/API_SPEC.md). The list
/// endpoint takes `lat`/`lng` and returns distance-sorted stores — used by
/// the "Nearby stores" map screen once the device's GPS position is known.
class StoresRepository {
  StoresRepository(this._client);

  final ApiClient _client;

  Future<List<Store>> getNearbyStores({
    required double lat,
    required double lng,
    String? country,
  }) async {
    // GET /stores wraps its array in {"data": [...]} (see
    // CatalogHandler.Stores) — use `get`, not `getRaw`, to match that shape.
    final json = await _client.get('/stores', queryParameters: {
      'lat': lat,
      'lng': lng,
      'country': ?country,
    });
    final list = (json['data'] as List<dynamic>?) ?? const [];
    return list.map((e) => Store.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Store> getStore(String storeId) async {
    final json = await _client.get('/stores/$storeId');
    return Store.fromJson(json);
  }
}

final storesRepositoryProvider = Provider<StoresRepository>((ref) {
  return StoresRepository(ref.watch(apiClientProvider));
});
