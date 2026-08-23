import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/address.dart';
import '../data/address_repository.dart';

/// Owns the user's saved addresses (`/addresses*` — docs/API_SPEC.md), used
/// by both the addresses management screen and checkout's address picker.
class AddressesController extends AsyncNotifier<List<Address>> {
  @override
  Future<List<Address>> build() {
    return ref.watch(addressRepositoryProvider).getAddresses();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<Address>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(addressRepositoryProvider).getAddresses());
  }

  Future<void> addAddress(Address address) async {
    await ref.read(addressRepositoryProvider).createAddress(address);
    await refresh();
  }

  Future<void> deleteAddress(String id) async {
    await ref.read(addressRepositoryProvider).deleteAddress(id);
    await refresh();
  }

  Future<void> setDefault(String id) async {
    await ref.read(addressRepositoryProvider).setDefault(id);
    await refresh();
  }
}

final addressesControllerProvider =
    AsyncNotifierProvider<AddressesController, List<Address>>(AddressesController.new);
