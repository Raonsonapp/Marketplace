// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: json['id'] as String,
  city: json['city'] as String,
  street: json['street'] as String,
  house: json['house'] as String?,
  apartment: json['apartment'] as String?,
  entrance: json['entrance'] as String?,
  floor: json['floor'] as String?,
  comment: json['comment'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'city': instance.city,
  'street': instance.street,
  'house': ?instance.house,
  'apartment': ?instance.apartment,
  'entrance': ?instance.entrance,
  'floor': ?instance.floor,
  'comment': ?instance.comment,
  'lat': ?instance.lat,
  'lng': ?instance.lng,
  'is_default': instance.isDefault,
};
