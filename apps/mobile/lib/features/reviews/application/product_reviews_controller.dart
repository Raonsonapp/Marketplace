import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_state.dart';
import '../data/review_models.dart';
import '../data/reviews_repository.dart';

/// Paginated approved-review list for one product
/// (`GET /reviews?product_id=` — docs/API_SPEC.md), shown on the product
/// detail screen. Mirrors `CategoryProductsController`'s per-arg shape.
class ProductReviewsController extends FamilyAsyncNotifier<PaginatedState<Review>, String> {
  late String _productId;

  @override
  Future<PaginatedState<Review>> build(String arg) async {
    _productId = arg;
    final page = await ref.watch(reviewsRepositoryProvider).getReviews(productId: _productId);
    return PaginatedState(items: page.data, nextCursor: page.nextCursor);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(reviewsRepositoryProvider)
          .getReviews(productId: _productId, cursor: current.nextCursor);
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
    state = const AsyncLoading<PaginatedState<Review>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final page = await ref.read(reviewsRepositoryProvider).getReviews(productId: _productId);
      return PaginatedState(items: page.data, nextCursor: page.nextCursor);
    });
  }
}

final productReviewsControllerProvider = AsyncNotifierProvider.family<ProductReviewsController,
    PaginatedState<Review>, String>(ProductReviewsController.new);
