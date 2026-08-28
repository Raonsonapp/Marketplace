// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_City _$CityFromJson(Map<String, dynamic> json) => _City(
  id: json['id'] as String,
  nameTg: json['name_tg'] as String,
  nameRu: json['name_ru'] as String,
  nameEn: json['name_en'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
);

Map<String, dynamic> _$CityToJson(_City instance) => <String, dynamic>{
  'id': instance.id,
  'name_tg': instance.nameTg,
  'name_ru': instance.nameRu,
  'name_en': instance.nameEn,
  'lat': instance.lat,
  'lng': instance.lng,
};

_Country _$CountryFromJson(Map<String, dynamic> json) => _Country(
  code: json['code'] as String,
  nameTg: json['name_tg'] as String,
  nameRu: json['name_ru'] as String,
  nameEn: json['name_en'] as String,
  currencyCode: json['currency_code'] as String,
  currencyTg: json['currency_tg'] as String,
  currencyRu: json['currency_ru'] as String,
  currencyEn: json['currency_en'] as String,
  dialCode: json['dial_code'] as String,
  centerLat: (json['center_lat'] as num).toDouble(),
  centerLng: (json['center_lng'] as num).toDouble(),
  cities:
      (json['cities'] as List<dynamic>?)
          ?.map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <City>[],
);

Map<String, dynamic> _$CountryToJson(_Country instance) => <String, dynamic>{
  'code': instance.code,
  'name_tg': instance.nameTg,
  'name_ru': instance.nameRu,
  'name_en': instance.nameEn,
  'currency_code': instance.currencyCode,
  'currency_tg': instance.currencyTg,
  'currency_ru': instance.currencyRu,
  'currency_en': instance.currencyEn,
  'dial_code': instance.dialCode,
  'center_lat': instance.centerLat,
  'center_lng': instance.centerLng,
  'cities': instance.cities.map((e) => e.toJson()).toList(),
};
