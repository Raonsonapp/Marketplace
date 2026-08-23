import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/address.dart';
import '../../../core/network/api_client.dart';

/// Calls `/addresses*` (docs/API_SPEC.md). Used by both the checkout flow
/// (address selection) and Profile → My addresses (CRUD).
class AddressRepository {
  AddressRepository(this._client);

  final ApiClient _client;

  Future<List<Address>> getAddresses() async {
    final raw = await _client.getRaw('/addresses');
    final list = (raw as List<dynamic>?) ?? const [];
    return list.map((e) => Address.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Address> createAddress(Address address) async {
    final json = await _client.post('/addresses', data: address.toJson()..remove('id'));
    return Address.fromJson(json);
  }

  Future<Address> updateAddress(Address address) async {
    final json = await _client.patch('/addresses/${address.id}', data: address.toJson());
    return Address.fromJson(json);
  }

  Future<void> deleteAddress(String id) => _client.delete('/addresses/$id');

  Future<void> setDefault(String id) => _client.post('/addresses/$id/default');
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(ref.watch(apiClientProvider));
});
