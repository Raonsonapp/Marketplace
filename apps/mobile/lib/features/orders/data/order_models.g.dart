// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItemLine _$OrderItemLineFromJson(Map<String, dynamic> json) =>
    _OrderItemLine(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      nameSnapshot: json['name_snapshot'] as String,
      unitPrice: json['unit_price'] as String,
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: json['total_price'] as String,
    );

Map<String, dynamic> _$OrderItemLineToJson(_OrderItemLine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'name_snapshot': instance.nameSnapshot,
      'unit_price': instance.unitPrice,
      'quantity': instance.quantity,
      'total_price': instance.totalPrice,
    };

_OrderStatusEvent _$OrderStatusEventFromJson(Map<String, dynamic> json) =>
    _OrderStatusEvent(
      status: json['status'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$OrderStatusEventToJson(_OrderStatusEvent instance) =>
    <String, dynamic>{
      'status': instance.status,
      'note': ?instance.note,
      'created_at': instance.createdAt.toIso8601String(),
    };

_OrderSummary _$OrderSummaryFromJson(Map<String, dynamic> json) =>
    _OrderSummary(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      total: json['total'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OrderSummaryToJson(_OrderSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'total': instance.total,
      'created_at': instance.createdAt.toIso8601String(),
      'item_count': instance.itemCount,
    };

_OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => _OrderDetail(
  id: json['id'] as String,
  orderNumber: json['order_number'] as String,
  status: json['status'] as String,
  deliveryMethod: json['delivery_method'] as String,
  paymentMethod: json['payment_method'] as String,
  subtotal: json['subtotal'] as String,
  discountAmount: json['discount_amount'] as String? ?? '0.00',
  deliveryFee: json['delivery_fee'] as String? ?? '0.00',
  bonusUsed: json['bonus_used'] as String? ?? '0.00',
  total: json['total'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  scheduledAt: json['scheduled_at'] == null
      ? null
      : DateTime.parse(json['scheduled_at'] as String),
  deliveryNote: json['delivery_note'] as String?,
  cancelledReason: json['cancelled_reason'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderItemLine>[],
  statusHistory:
      (json['status_history'] as List<dynamic>?)
          ?.map((e) => OrderStatusEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderStatusEvent>[],
);

Map<String, dynamic> _$OrderDetailToJson(_OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'delivery_method': instance.deliveryMethod,
      'payment_method': instance.paymentMethod,
      'subtotal': instance.subtotal,
      'discount_amount': instance.discountAmount,
      'delivery_fee': instance.deliveryFee,
      'bonus_used': instance.bonusUsed,
      'total': instance.total,
      'created_at': instance.createdAt.toIso8601String(),
      'scheduled_at': ?instance.scheduledAt?.toIso8601String(),
      'delivery_note': ?instance.deliveryNote,
      'cancelled_reason': ?instance.cancelledReason,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'status_history': instance.statusHistory.map((e) => e.toJson()).toList(),
    };
