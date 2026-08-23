import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_state.dart';
import '../../../core/models/product.dart';
import '../data/favorites_repository.dart';

/// Paginated favorites list for the Favorites screen (`GET /favorites` —
/// docs/API_SPEC.md).
class FavoritesListController extends AsyncNotifier<PaginatedState<Product>> {
  @override
  Future<PaginatedState<Product>> build() async {
    final page = await ref.watch(favoritesRepositoryProvider).getFavorites();
    return PaginatedState(items: page.data, nextCursor: page.nextCursor);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page =
          await ref.read(favoritesRepositoryProvider).getFavorites(cursor: current.nextCursor);
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
    state = const AsyncLoading<PaginatedState<Product>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final page = await ref.read(favoritesRepositoryProvider).getFavorites();
      return PaginatedState(items: page.data, nextCursor: page.nextCursor);
    });
  }

  /// Removes [productId] from the visible list only. The actual
  /// add/remove API call is made by `FavoriteIdsController.toggle` — this
  /// just keeps this screen's list in sync with that source of truth.
  void removeLocally(String productId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      items: current.items.where((p) => p.id != productId).toList(),
    ));
  }
}

final favoritesListControllerProvider =
    AsyncNotifierProvider<FavoritesListController, PaginatedState<Product>>(
        FavoritesListController.new);
