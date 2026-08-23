import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_state.dart';
import '../data/loyalty_models.dart';
import '../data/loyalty_repository.dart';

/// Paginated TajBonus ledger for the loyalty screen
/// (`GET /loyalty/transactions` — docs/API_SPEC.md). Mirrors
/// `FavoritesListController`'s load-more/refresh shape.
class LoyaltyTransactionsController extends AsyncNotifier<PaginatedState<LoyaltyTransaction>> {
  @override
  Future<PaginatedState<LoyaltyTransaction>> build() async {
    final page = await ref.watch(loyaltyRepositoryProvider).getTransactions();
    return PaginatedState(items: page.data, nextCursor: page.nextCursor);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(loyaltyRepositoryProvider)
          .getTransactions(cursor: current.nextCursor);
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
    state = const AsyncLoading<PaginatedState<LoyaltyTransaction>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final page = await ref.read(loyaltyRepositoryProvider).getTransactions();
      return PaginatedState(items: page.data, nextCursor: page.nextCursor);
    });
  }
}

final loyaltyTransactionsControllerProvider = AsyncNotifierProvider<LoyaltyTransactionsController,
    PaginatedState<LoyaltyTransaction>>(LoyaltyTransactionsController.new);
