import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'cargo_models.dart';

/// Calls `/cargo*` (docs/API_SPEC.md) — parcel forwarding from China to
/// Tajikistan and Russia.
class CargoRepository {
  CargoRepository(this._client);

  final ApiClient _client;

  /// Public: the destinations forwarding is offered for. An empty list is a
  /// valid answer (no operator has set the service up yet), not an error.
  Future<List<CargoTariff>> getTariffs() async {
    final json = await _client.get('/cargo/tariffs');
    final list = (json['data'] as List<dynamic>?) ?? const [];
    return list.map((e) => CargoTariff.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CargoShipment>> getShipments() async {
    final json = await _client.get('/cargo');
    final list = (json['data'] as List<dynamic>?) ?? const [];
    return list.map((e) => CargoShipment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CargoShipment> register({
    required String destination,
    required String description,
    String? trackCode,
    String? productLink,
  }) async {
    final json = await _client.post('/cargo', data: {
      'destination': destination,
      'description': description,
      'track_code': ?trackCode,
      'product_link': ?productLink,
    });
    return CargoShipment.fromJson(json);
  }

  Future<CargoShipment> cancel(String id) async {
    final json = await _client.post('/cargo/$id/cancel');
    return CargoShipment.fromJson(json);
  }
}

final cargoRepositoryProvider = Provider<CargoRepository>((ref) {
  return CargoRepository(ref.watch(apiClientProvider));
});
