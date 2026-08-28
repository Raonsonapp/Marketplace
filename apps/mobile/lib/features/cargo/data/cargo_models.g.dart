// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cargo_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CargoTariff _$CargoTariffFromJson(Map<String, dynamic> json) => _CargoTariff(
  destination: json['destination'] as String,
  ratePerKg: json['rate_per_kg'] as String,
  warehouseAddress: json['warehouse_address'] as String? ?? '',
  contactPhone: json['contact_phone'] as String? ?? '',
  estimatedDaysMin: (json['estimated_days_min'] as num?)?.toInt(),
  estimatedDaysMax: (json['estimated_days_max'] as num?)?.toInt(),
);

Map<String, dynamic> _$CargoTariffToJson(_CargoTariff instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'rate_per_kg': instance.ratePerKg,
      'warehouse_address': instance.warehouseAddress,
      'contact_phone': instance.contactPhone,
      'estimated_days_min': ?instance.estimatedDaysMin,
      'estimated_days_max': ?instance.estimatedDaysMax,
    };

_CargoShipment _$CargoShipmentFromJson(Map<String, dynamic> json) =>
    _CargoShipment(
      id: json['id'] as String,
      description: json['description'] as String,
      destination: json['destination'] as String,
      trackCode: json['track_code'] as String?,
      productLink: json['product_link'] as String?,
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0,
      cost: json['cost'] as String? ?? '0.00',
      status:
          $enumDecodeNullable(_$CargoStatusEnumMap, json['status']) ??
          CargoStatus.registered,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CargoShipmentToJson(_CargoShipment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'destination': instance.destination,
      'track_code': ?instance.trackCode,
      'product_link': ?instance.productLink,
      'weight_kg': instance.weightKg,
      'cost': instance.cost,
      'status': _$CargoStatusEnumMap[instance.status]!,
      'note': ?instance.note,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$CargoStatusEnumMap = {
  CargoStatus.registered: 'new',
  CargoStatus.received: 'received',
  CargoStatus.shipped: 'shipped',
  CargoStatus.arrived: 'arrived',
  CargoStatus.delivered: 'delivered',
  CargoStatus.cancelled: 'cancelled',
};
