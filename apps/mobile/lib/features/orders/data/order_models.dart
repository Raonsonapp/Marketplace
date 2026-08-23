import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_models.freezed.dart';
part 'order_models.g.dart';

/// Order lifecycle states, matching docs/DATABASE_SCHEMA.md's
/// `orders.status` CHECK constraint exactly (including its order).
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  courierAssigned,
  pickedUp,
  delivering,
  delivered,
  cancelled;

  static OrderStatus fromApi(String value) {
    return switch (value) {
      'pending' => OrderStatus.pending,
      'confirmed' => OrderStatus.confirmed,
      'preparing' => OrderStatus.preparing,
      'ready' => OrderStatus.ready,
      'courier_assigned' => OrderStatus.courierAssigned,
      'picked_up' => OrderStatus.pickedUp,
      'delivering' => OrderStatus.delivering,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.pending,
    };
  }

  String get apiValue => switch (this) {
        OrderStatus.pending => 'pending',
        OrderStatus.confirmed => 'confirmed',
        OrderStatus.preparing => 'preparing',
        OrderStatus.ready => 'ready',
        OrderStatus.courierAssigned => 'courier_assigned',
        OrderStatus.pickedUp => 'picked_up',
        OrderStatus.delivering => 'delivering',
        OrderStatus.delivered => 'delivered',
        OrderStatus.cancelled => 'cancelled',
      };

  bool get isActive => this != OrderStatus.delivered && this != OrderStatus.cancelled;
  bool get isCompleted => this == OrderStatus.delivered;
  bool get isCancelled => this == OrderStatus.cancelled;
}

@freezed
abstract class OrderItemLine with _$OrderItemLine {
  const factory OrderItemLine({
    // `order_items.id` (docs/DATABASE_SCHEMA.md) — this is the
    // `order_item_id` that `POST /reviews` requires, so a review always
    // ties back to a real purchased line, never a client-invented id.
    required String id,
    required String productId,
    required String nameSnapshot,
    required String unitPrice,
    required int quantity,
    required String totalPrice,
  }) = _OrderItemLine;

  factory OrderItemLine.fromJson(Map<String, dynamic> json) => _$OrderItemLineFromJson(json);
}

@freezed
abstract class OrderStatusEvent with _$OrderStatusEvent {
  const factory OrderStatusEvent({
    required String status,
    String? note,
    required DateTime createdAt,
  }) = _OrderStatusEvent;

  factory OrderStatusEvent.fromJson(Map<String, dynamic> json) => _$OrderStatusEventFromJson(json);
}

/// Order list row (`GET /orders` — docs/API_SPEC.md).
@freezed
abstract class OrderSummary with _$OrderSummary {
  const factory OrderSummary({
    required String id,
    required String orderNumber,
    required String status,
    required String total,
    required DateTime createdAt,
    @Default(0) int itemCount,
  }) = _OrderSummary;

  factory OrderSummary.fromJson(Map<String, dynamic> json) => _$OrderSummaryFromJson(json);
}

/// Full order detail (`GET /orders/:id` — docs/API_SPEC.md).
@freezed
abstract class OrderDetail with _$OrderDetail {
  const factory OrderDetail({
    required String id,
    required String orderNumber,
    required String status,
    required String deliveryMethod,
    required String paymentMethod,
    required String subtotal,
    @Default('0.00') String discountAmount,
    @Default('0.00') String deliveryFee,
    @Default('0.00') String bonusUsed,
    required String total,
    required DateTime createdAt,
    DateTime? scheduledAt,
    String? deliveryNote,
    String? cancelledReason,
    @Default(<OrderItemLine>[]) List<OrderItemLine> items,
    @Default(<OrderStatusEvent>[]) List<OrderStatusEvent> statusHistory,
  }) = _OrderDetail;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => _$OrderDetailFromJson(json);
}
