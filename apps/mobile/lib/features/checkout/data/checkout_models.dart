import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_models.freezed.dart';
part 'checkout_models.g.dart';

/// Delivery method accepted by checkout/orders (docs/DATABASE_SCHEMA.md:
/// `orders.delivery_method` CHECK `('delivery','pickup')`).
enum DeliveryMethod {
  delivery,
  pickup;

  String get apiValue => this == DeliveryMethod.delivery ? 'delivery' : 'pickup';
}

/// `POST /checkout/quote` response — the server-computed preview shown
/// before the user places an order (docs/API_SPEC.md, docs/SECURITY.md: the
/// client only ever displays this, never recomputes it).
@freezed
abstract class CheckoutQuote with _$CheckoutQuote {
  const factory CheckoutQuote({
    required String subtotal,
    @Default('0.00') String discount,
    @Default('0.00') String deliveryFee,
    @Default('0.00') String bonusUsed,
    required String total,
    int? estimatedMinutes,
  }) = _CheckoutQuote;

  factory CheckoutQuote.fromJson(Map<String, dynamic> json) => _$CheckoutQuoteFromJson(json);
}

/// `POST /orders` response — just enough to route to the order-detail
/// screen and show the confirmation.
@freezed
abstract class PlacedOrder with _$PlacedOrder {
  const factory PlacedOrder({
    required String id,
    required String orderNumber,
    required String total,
  }) = _PlacedOrder;

  factory PlacedOrder.fromJson(Map<String, dynamic> json) => _$PlacedOrderFromJson(json);
}
