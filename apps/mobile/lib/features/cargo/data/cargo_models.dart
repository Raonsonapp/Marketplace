import 'package:freezed_annotation/freezed_annotation.dart';

part 'cargo_models.freezed.dart';
part 'cargo_models.g.dart';

/// Where the shopper's parcel is in the China → Tajikistan/Russia pipeline
/// (`cargo_shipments.status` — docs/DATABASE_SCHEMA.md).
enum CargoStatus {
  @JsonValue('new')
  registered,
  @JsonValue('received')
  received,
  @JsonValue('shipped')
  shipped,
  @JsonValue('arrived')
  arrived,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled;

  /// Where this status sits on the four-step progress bar, or null for the
  /// terminal states that are not part of the forward path.
  int? get stepIndex => switch (this) {
        CargoStatus.registered => 0,
        CargoStatus.received => 1,
        CargoStatus.shipped => 2,
        CargoStatus.arrived => 3,
        CargoStatus.delivered => 4,
        CargoStatus.cancelled => null,
      };

  /// Only a parcel the warehouse has not touched yet can be withdrawn by
  /// the shopper; anything further along is physically in motion. Mirrors
  /// the backend's own rule (CargoRepository.CancelByUser).
  bool get isCancelable => this == CargoStatus.registered;
}

/// One destination's forwarding offer from `GET /cargo/tariffs`: the China
/// warehouse address to ship to, the per-kilo price, and the transit time.
@freezed
abstract class CargoTariff with _$CargoTariff {
  const factory CargoTariff({
    required String destination,
    @JsonKey(name: 'rate_per_kg') required String ratePerKg,
    @JsonKey(name: 'warehouse_address') @Default('') String warehouseAddress,
    @JsonKey(name: 'contact_phone') @Default('') String contactPhone,
    @JsonKey(name: 'estimated_days_min') int? estimatedDaysMin,
    @JsonKey(name: 'estimated_days_max') int? estimatedDaysMax,
  }) = _CargoTariff;

  factory CargoTariff.fromJson(Map<String, dynamic> json) => _$CargoTariffFromJson(json);
}

/// A parcel the shopper registered (`GET /cargo`, `POST /cargo`).
@freezed
abstract class CargoShipment with _$CargoShipment {
  const factory CargoShipment({
    required String id,
    required String description,
    required String destination,
    @JsonKey(name: 'track_code') String? trackCode,
    @JsonKey(name: 'product_link') String? productLink,
    /// Zero until an operator weighs the parcel at the China warehouse —
    /// which is also when [cost] stops being zero.
    @JsonKey(name: 'weight_kg') @Default(0) double weightKg,
    @Default('0.00') String cost,
    @Default(CargoStatus.registered) CargoStatus status,
    String? note,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _CargoShipment;

  const CargoShipment._();

  factory CargoShipment.fromJson(Map<String, dynamic> json) => _$CargoShipmentFromJson(json);

  /// True once the operator has priced the parcel; before that the app shows
  /// "awaiting weighing" rather than a misleading 0.00.
  bool get isPriced => weightKg > 0;
}
