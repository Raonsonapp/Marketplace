// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Store _$StoreFromJson(Map<String, dynamic> json) => _Store(
  id: json['id'] as String,
  name: json['name'] as String,
  logoUrl: json['logo_url'] as String?,
  address: json['address'] as String?,
  distanceKm: (json['distance_km'] as num?)?.toDouble(),
  isDeliveryAvailable: json['is_delivery_available'] as bool? ?? true,
  isPickupAvailable: json['is_pickup_available'] as bool? ?? true,
  isOpen: json['is_open'] as bool? ?? true,
);

Map<String, dynamic> _$StoreToJson(_Store instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logo_url': ?instance.logoUrl,
  'address': ?instance.address,
  'distance_km': ?instance.distanceKm,
  'is_delivery_available': instance.isDeliveryAvailable,
  'is_pickup_available': instance.isPickupAvailable,
  'is_open': instance.isOpen,
};
