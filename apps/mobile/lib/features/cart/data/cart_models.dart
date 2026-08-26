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
    @JsonKey(name: 'line_total') required String lineTotal,
    @JsonKey(name: 'available') @Default(true) bool isAvailable,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}

/// `GET /cart` response. `subtotal` is the only total the backend computes
/// at this stage (`services/api/internal/httpapi/dto/cart.go`) — discount,
/// delivery fee, and the final total all depend on a chosen address/delivery
/// method and are only known from `POST /checkout/quote`, shown on the
/// Checkout screen instead (`CheckoutQuoteSummary`).
@freezed
abstract class Cart with _$Cart {
  const factory Cart({
    @Default(<CartItem>[]) List<CartItem> items,
    @Default(<CartItem>[]) List<CartItem> savedForLater,
    required String subtotal,
  }) = _Cart;

  const Cart._();

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  static const empty = Cart(items: [], savedForLater: [], subtotal: '0.00');
}
