// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  id: json['id'] as String,
  product: Product.fromJson(json['product'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num).toInt(),
  lineTotal: json['line_total'] as String,
  isAvailable: json['is_available'] as bool? ?? true,
  savedForLater: json['saved_for_later'] as bool? ?? false,
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'product': instance.product.toJson(),
  'quantity': instance.quantity,
  'line_total': instance.lineTotal,
  'is_available': instance.isAvailable,
  'saved_for_later': instance.savedForLater,
};

_Cart _$CartFromJson(Map<String, dynamic> json) => _Cart(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CartItem>[],
  savedForLater:
      (json['saved_for_later'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CartItem>[],
  subtotal: json['subtotal'] as String,
  discount: json['discount'] as String? ?? '0.00',
  deliveryFee: json['delivery_fee'] as String? ?? '0.00',
  total: json['total'] as String,
  promoCode: json['promo_code'] as String?,
);

Map<String, dynamic> _$CartToJson(_Cart instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'saved_for_later': instance.savedForLater.map((e) => e.toJson()).toList(),
  'subtotal': instance.subtotal,
  'discount': instance.discount,
  'delivery_fee': instance.deliveryFee,
  'total': instance.total,
  'promo_code': ?instance.promoCode,
};
