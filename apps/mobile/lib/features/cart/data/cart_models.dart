import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/product.dart';

part 'cart_models.freezed.dart';
part 'cart_models.g.dart';

/// A single cart line (`GET /cart` item — docs/API_SPEC.md). Carries a
/// live-recalculated [lineTotal] and [isAvailable] flag since the server
/// re-checks price/stock on every cart read.
@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required Product product,
    required int quantity,
    required String lineTotal,
    @Default(true) bool isAvailable,
    @Default(false) bool savedForLater,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}

/// `GET /cart` response. Every money field is server-computed — the UI
/// only ever displays these values, never derives its own (docs/SECURITY.md:
/// "client never computes money").
@freezed
abstract class Cart with _$Cart {
  const factory Cart({
    @Default(<CartItem>[]) List<CartItem> items,
    @Default(<CartItem>[]) List<CartItem> savedForLater,
    required String subtotal,
    @Default('0.00') String discount,
    @Default('0.00') String deliveryFee,
    required String total,
    String? promoCode,
  }) = _Cart;

  const Cart._();

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  static const empty = Cart(items: [], savedForLater: [], subtotal: '0.00', total: '0.00');
}
