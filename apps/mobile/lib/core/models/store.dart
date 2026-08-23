import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

/// A store/pickup point from `GET /stores`, `GET /stores/:id`, and the
/// home feed's `nearby_stores` section (see docs/API_SPEC.md).
@freezed
abstract class Store with _$Store {
  const factory Store({
    required String id,
    required String name,
    String? logoUrl,
    String? address,
    double? distanceKm,
    @Default(true) bool isDeliveryAvailable,
    @Default(true) bool isPickupAvailable,
    @Default(true) bool isOpen,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}
