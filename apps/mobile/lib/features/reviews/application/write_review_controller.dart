import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/review_models.dart';
import '../data/reviews_repository.dart';

/// Drives the "write a review" form (`POST /reviews` — docs/API_SPEC.md).
/// A plain (non-family) notifier scoped to whichever `WriteReviewScreen`
/// instance is currently on screen — like `ProfileController.updateProfile`,
/// the loading/error state lives in `state` and the screen reads it via
/// `ref.watch`/`ref.listen`.
class WriteReviewController extends AsyncNotifier<Review?> {
  @override
  Future<Review?> build() async => null;

  Future<void> submit({
    required String productId,
    required String orderItemId,
    required int rating,
    String? text,
    List<String>? images,
  }) async {
    state = const AsyncLoading<Review?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(reviewsRepositoryProvider).submitReview(
          productId: productId,
          orderItemId: orderItemId,
          rating: rating,
          text: text,
          images: images,
        ));
  }
}

final writeReviewControllerProvider =
    AsyncNotifierProvider<WriteReviewController, Review?>(WriteReviewController.new);
