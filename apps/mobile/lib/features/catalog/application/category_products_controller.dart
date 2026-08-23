import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_state.dart';
import '../../../core/models/product.dart';
import '../data/catalog_repository.dart';

/// Paginated product list for a single category
/// (`GET /categories/:id/products`, cursor-based — docs/API_SPEC.md).
class CategoryProductsController extends FamilyAsyncNotifier<PaginatedState<Product>, String> {
  late String _categoryId;

  @override
  Future<PaginatedState<Product>> build(String arg) async {
    _categoryId = arg;
    final page = await ref.watch(catalogRepositoryProvider).getCategoryProducts(_categoryId);
    return PaginatedState(items: page.data, nextCursor: page.nextCursor);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref.read(catalogRepositoryProvider).getCategoryProducts(
            _categoryId,
            cursor: current.nextCursor,
          );
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
      final page = await ref.read(catalogRepositoryProvider).getCategoryProducts(_categoryId);
      return PaginatedState(items: page.data, nextCursor: page.nextCursor);
    });
  }
}

final categoryProductsControllerProvider = AsyncNotifierProvider.family<CategoryProductsController,
    PaginatedState<Product>, String>(CategoryProductsController.new);
