import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/address.dart';
import '../../../core/network/api_client.dart';

/// Calls `/addresses*` (docs/API_SPEC.md). Used by both the checkout flow
/// (address selection) and Profile → My addresses (CRUD).
class AddressRepository {
  AddressRepository(this._client);

  final ApiClient _client;

  Future<List<Address>> getAddresses() async {
    // GET /addresses wraps its array in {"data": [...]} (see
    // AddressHandler.List) — use `get`, not `getRaw`, to match that shape.
    final json = await _client.get('/addresses');
    final list = (json['data'] as List<dynamic>?) ?? const [];
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

  /// There's no dedicated "set default" endpoint — `PATCH /addresses/:id`
  /// already demotes every other address when `is_default: true` is patched
  /// (see `AddressRepository.Update` in the backend), so this is just that.
  Future<Address> setDefault(String id) async {
    final json = await _client.patch('/addresses/$id', data: {'is_default': true});
    return Address.fromJson(json);
  }
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(ref.watch(apiClientProvider));
});
