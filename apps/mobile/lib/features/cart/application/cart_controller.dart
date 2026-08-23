import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_controller.dart';
import '../data/cart_models.dart';
import '../data/cart_repository.dart';

/// Owns the current cart. Every mutation re-fetches/re-derives the cart from
/// the server's response rather than computing a new total locally
/// (docs/SECURITY.md).
class CartController extends AsyncNotifier<Cart> {
  @override
  Future<Cart> build() async {
    final isAuthenticated =
        ref.watch(sessionControllerProvider).valueOrNull?.isAuthenticated ?? false;
    if (!isAuthenticated) return Cart.empty;
    return ref.watch(cartRepositoryProvider).getCart();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<Cart>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(cartRepositoryProvider).getCart());
  }

  Future<void> addItem({required String productId, required int quantity}) async {
    state = await AsyncValue.guard(
      () => ref.read(cartRepositoryProvider).addItem(productId: productId, quantity: quantity),
    );
  }

  Future<void> updateQuantity({required String cartItemId, required int quantity}) async {
    final previous = state;
    state = await AsyncValue.guard(
      () => ref.read(cartRepositoryProvider).updateItemQuantity(
            cartItemId: cartItemId,
            quantity: quantity,
          ),
    );
    if (state.hasError) state = previous;
  }

  Future<void> removeItem(String cartItemId) async {
    try {
      await ref.read(cartRepositoryProvider).removeItem(cartItemId);
      await refresh();
    } catch (_) {
      await refresh();
    }
  }

  Future<void> saveForLater(String cartItemId) async {
    await ref.read(cartRepositoryProvider).saveForLater(cartItemId);
    await refresh();
  }

  Future<void> clearCart() async {
    await ref.read(cartRepositoryProvider).clearCart();
    await refresh();
  }

  Future<void> applyPromoCode(String code) async {
    state = await AsyncValue.guard(() => ref.read(cartRepositoryProvider).applyPromoCode(code));
  }

  Future<void> removePromoCode() async {
    state = await AsyncValue.guard(() => ref.read(cartRepositoryProvider).removePromoCode());
  }
}

final cartControllerProvider = AsyncNotifierProvider<CartController, Cart>(CartController.new);
