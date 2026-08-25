import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_controller.dart';
import '../data/favorites_repository.dart';

/// Tracks the set of favorited product ids app-wide so every [ProductCard]
/// (home, catalog, search, product detail, favorites) reflects the same
/// favorite state without each feature keeping its own copy in sync.
///
/// Anonymous users never call `/favorites` (it requires a session); the set
/// simply starts empty for them.
class FavoriteIdsController extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    // .select avoids refetching the whole favorites list on every
    // SessionState change (e.g. a profile field update) when only the
    // isAuthenticated flag is actually needed.
    final isAuthenticated = ref.watch(
      sessionControllerProvider.select((s) => s.valueOrNull?.isAuthenticated ?? false),
    );
    if (!isAuthenticated) return <String>{};

    final ids = <String>{};
    String? cursor;
    do {
      final page = await ref.read(favoritesRepositoryProvider).getFavorites(cursor: cursor);
      ids.addAll(page.data.map((p) => p.id));
      cursor = page.nextCursor;
    } while (cursor != null);
    return ids;
  }

  Future<void> toggle(String productId) async {
    final current = state.valueOrNull ?? <String>{};
    final isFavorite = current.contains(productId);
    final optimistic = {...current};
    if (isFavorite) {
      optimistic.remove(productId);
    } else {
      optimistic.add(productId);
    }
    state = AsyncData(optimistic);

    try {
      if (isFavorite) {
        await ref.read(favoritesRepositoryProvider).removeFavorite(productId);
      } else {
        await ref.read(favoritesRepositoryProvider).addFavorite(productId);
      }
    } catch (_) {
      // Revert the optimistic update on failure.
      state = AsyncData(current);
      rethrow;
    }
  }
}

final favoriteIdsControllerProvider =
    AsyncNotifierProvider<FavoriteIdsController, Set<String>>(FavoriteIdsController.new);
