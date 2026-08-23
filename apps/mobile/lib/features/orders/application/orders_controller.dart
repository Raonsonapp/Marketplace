import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_state.dart';
import '../data/order_models.dart';
import '../data/orders_repository.dart';

/// Paginated order list for one tab (active/completed/cancelled —
/// `GET /orders?status=` — docs/API_SPEC.md).
class OrdersController extends FamilyAsyncNotifier<PaginatedState<OrderSummary>, OrdersFilter> {
  late OrdersFilter _filter;

  @override
  Future<PaginatedState<OrderSummary>> build(OrdersFilter arg) async {
    _filter = arg;
    final page = await ref.watch(ordersRepositoryProvider).getOrders(filter: _filter);
    return PaginatedState(items: page.data, nextCursor: page.nextCursor);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(ordersRepositoryProvider)
          .getOrders(filter: _filter, cursor: current.nextCursor);
      state = AsyncData(current.copyWith(
        items: [...current.items, ...page.data],
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
        isLoadingMore: false,
      ));
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading<PaginatedState<OrderSummary>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final page = await ref.read(ordersRepositoryProvider).getOrders(filter: _filter);
      return PaginatedState(items: page.data, nextCursor: page.nextCursor);
    });
  }
}

final ordersControllerProvider = AsyncNotifierProvider.family<OrdersController,
    PaginatedState<OrderSummary>, OrdersFilter>(OrdersController.new);
