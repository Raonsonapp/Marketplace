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

  /// Toggles the current user's helpful vote on [review], updating that one
  /// row optimistically and reconciling the count with the server's reply.
  /// A failed request rolls the row back to its previous state.
  Future<void> toggleHelpful(Review review) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final willVote = !review.viewerVoted;

    Review apply(Review r) => r.copyWith(
          viewerVoted: willVote,
          helpfulCount: (r.helpfulCount + (willVote ? 1 : -1)).clamp(0, 1 << 30),
        );
    List<Review> replace(List<Review> items, Review value) =>
        [for (final r in items) if (r.id == review.id) value else r];

    final optimistic = apply(review);
    state = AsyncData(current.copyWith(items: replace(current.items, optimistic)));

    try {
      final count = await ref
          .read(reviewsRepositoryProvider)
          .setHelpful(reviewId: review.id, helpful: willVote);
      final latest = state.valueOrNull;
      if (latest == null) return;
      state = AsyncData(latest.copyWith(
        items: replace(latest.items, optimistic.copyWith(helpfulCount: count)),
      ));
    } catch (_) {
      final latest = state.valueOrNull;
      if (latest == null) return;
      state = AsyncData(latest.copyWith(items: replace(latest.items, review)));
    }
  }
}

final productReviewsControllerProvider = AsyncNotifierProvider.family<ProductReviewsController,
    PaginatedState<Review>, String>(ProductReviewsController.new);
