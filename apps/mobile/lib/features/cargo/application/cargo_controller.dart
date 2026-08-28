import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/cargo_models.dart';
import '../data/cargo_repository.dart';

/// The destinations parcel forwarding is offered for. Loaded once and shared
/// by the info card and the registration form.
final cargoTariffsProvider = FutureProvider<List<CargoTariff>>((ref) async {
  return ref.watch(cargoRepositoryProvider).getTariffs();
});

/// The caller's own parcels.
class CargoShipmentsController extends AsyncNotifier<List<CargoShipment>> {
  @override
  Future<List<CargoShipment>> build() {
    return ref.watch(cargoRepositoryProvider).getShipments();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<CargoShipment>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(cargoRepositoryProvider).getShipments());
  }

  /// Registers a parcel and puts it at the top of the list without a
  /// refetch. Rethrows so the form can show the failure inline instead of
  /// replacing the whole list with an error state.
  Future<CargoShipment> register({
    required String destination,
    required String description,
    String? trackCode,
    String? productLink,
  }) async {
    final created = await ref.read(cargoRepositoryProvider).register(
          destination: destination,
          description: description,
          trackCode: trackCode,
          productLink: productLink,
        );
    state = AsyncData([created, ...state.valueOrNull ?? const []]);
    return created;
  }

  /// Withdraws a parcel the warehouse hasn't received yet, replacing it in
  /// place with the cancelled row the server returns.
  Future<void> cancel(String id) async {
    final cancelled = await ref.read(cargoRepositoryProvider).cancel(id);
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData([
      for (final shipment in current) shipment.id == id ? cancelled : shipment,
    ]);
  }
}

final cargoShipmentsControllerProvider =
    AsyncNotifierProvider<CargoShipmentsController, List<CargoShipment>>(
  CargoShipmentsController.new,
);
