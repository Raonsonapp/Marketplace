// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Promotion _$PromotionFromJson(Map<String, dynamic> json) => _Promotion(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  imageUrl: json['image_url'] as String?,
  discountType: json['discount_type'] as String,
  discountValue: json['discount_value'] as String,
  startsAt: json['starts_at'] == null
      ? null
      : DateTime.parse(json['starts_at'] as String),
  endsAt: json['ends_at'] == null
      ? null
      : DateTime.parse(json['ends_at'] as String),
  promoCode: json['promo_code'] as String?,
);

Map<String, dynamic> _$PromotionToJson(_Promotion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': ?instance.description,
      'image_url': ?instance.imageUrl,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'starts_at': ?instance.startsAt?.toIso8601String(),
      'ends_at': ?instance.endsAt?.toIso8601String(),
      'promo_code': ?instance.promoCode,
    };
