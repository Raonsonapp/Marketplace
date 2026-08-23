// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckoutQuote _$CheckoutQuoteFromJson(Map<String, dynamic> json) =>
    _CheckoutQuote(
      subtotal: json['subtotal'] as String,
      discount: json['discount'] as String? ?? '0.00',
      deliveryFee: json['delivery_fee'] as String? ?? '0.00',
      bonusUsed: json['bonus_used'] as String? ?? '0.00',
      total: json['total'] as String,
      estimatedMinutes: (json['estimated_minutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CheckoutQuoteToJson(_CheckoutQuote instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'delivery_fee': instance.deliveryFee,
      'bonus_used': instance.bonusUsed,
      'total': instance.total,
      'estimated_minutes': ?instance.estimatedMinutes,
    };

_PlacedOrder _$PlacedOrderFromJson(Map<String, dynamic> json) => _PlacedOrder(
  id: json['id'] as String,
  orderNumber: json['order_number'] as String,
  total: json['total'] as String,
);

Map<String, dynamic> _$PlacedOrderToJson(_PlacedOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'total': instance.total,
    };
