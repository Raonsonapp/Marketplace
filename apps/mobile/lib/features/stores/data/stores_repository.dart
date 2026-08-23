import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/store.dart';
import '../../../core/network/api_client.dart';

/// Calls `GET /stores` and `GET /stores/:id` (docs/API_SPEC.md). The list
/// endpoint takes `lat`/`lng` and returns distance-sorted stores — used by
/// the "Nearby stores" map screen once the device's GPS position is known.
class StoresRepository {
  StoresRepository(this._client);

  final ApiClient _client;

  Future<List<Store>> getNearbyStores({required double lat, required double lng}) async {
    final raw = await _client.getRaw('/stores', queryParameters: {
      'lat': lat,
      'lng': lng,
    });
    final list = (raw as List<dynamic>?) ?? const [];
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
