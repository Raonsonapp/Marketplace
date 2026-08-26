import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'cart_models.dart';

/// Calls `/cart*` (docs/API_SPEC.md). Every response is re-parsed into a
/// fresh [Cart] since the server recalculates prices/availability on every
/// read — the client never patches its local copy's money fields.
class CartRepository {
  CartRepository(this._client);

  final ApiClient _client;

  Future<Cart> getCart() async {
    final json = await _client.get('/cart');
    return Cart.fromJson(json);
  }

  Future<Cart> addItem({required String productId, required int quantity}) async {
    final json = await _client.post('/cart/items', data: {
      'product_id': productId,
      'quantity': quantity,
    });
    return Cart.fromJson(json);
  }

  Future<Cart> updateItemQuantity({required String cartItemId, required int quantity}) async {
    final json = await _client.patch('/cart/items/$cartItemId', data: {'quantity': quantity});
    return Cart.fromJson(json);
  }

  Future<void> removeItem(String cartItemId) => _client.delete('/cart/items/$cartItemId');

  Future<Cart> saveForLater(String cartItemId) async {
    final json = await _client.post('/cart/items/$cartItemId/save-for-later');
    return Cart.fromJson(json);
  }

  Future<Cart> moveToCart(String cartItemId) async {
    final json = await _client.post('/cart/items/$cartItemId/move-to-cart');
    return Cart.fromJson(json);
  }

  Future<void> clearCart() => _client.delete('/cart');
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(ref.watch(apiClientProvider));
});
