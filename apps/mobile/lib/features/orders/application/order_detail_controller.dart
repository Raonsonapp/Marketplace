import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/order_models.dart';
import '../data/orders_repository.dart';

/// Loads and mutates a single order (`GET/POST /orders/:id*` —
/// docs/API_SPEC.md).
class OrderDetailController extends FamilyAsyncNotifier<OrderDetail, String> {
  @override
  Future<OrderDetail> build(String arg) {
    return ref.watch(ordersRepositoryProvider).getOrder(arg);
  }

  Future<void> refresh() async {
    final id = arg;
    state = const AsyncLoading<OrderDetail>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(ordersRepositoryProvider).getOrder(id));
  }

  Future<void> cancel(String reason) async {
    await ref.read(ordersRepositoryProvider).cancelOrder(orderId: arg, reason: reason);
    await refresh();
  }

  Future<void> reorder() => ref.read(ordersRepositoryProvider).reorder(arg);
}

final orderDetailControllerProvider =
    AsyncNotifierProvider.family<OrderDetailController, OrderDetail, String>(
        OrderDetailController.new);
