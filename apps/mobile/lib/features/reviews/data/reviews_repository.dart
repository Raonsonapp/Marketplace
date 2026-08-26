import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_response.dart';
import '../../../core/network/api_client.dart';
import 'review_models.dart';

/// Calls `/reviews*` (docs/API_SPEC.md).
class ReviewsRepository {
  ReviewsRepository(this._client);

  final ApiClient _client;

  Future<PaginatedResponse<Review>> getReviews({required String productId, String? cursor}) async {
    final json = await _client.get('/reviews', queryParameters: {
      'product_id': productId,
      'cursor': ?cursor,
    });
    return PaginatedResponse.fromJson(json, Review.fromJson);
  }

  /// `order_item_id` ties the review to the specific purchased line it was
  /// written from — the caller must always pass a real id read off that
  /// order's items, never invent one (see `WriteReviewScreen`).
  Future<Review> submitReview({
    required String productId,
    required String orderItemId,
    required int rating,
    String? text,
    List<String>? images,
  }) async {
    final json = await _client.post('/reviews', data: {
      'product_id': productId,
      'order_item_id': orderItemId,
      'rating': rating,
      'text': ?text,
      'images': ?images,
    });
    return Review.fromJson(json);
  }

  /// Marks (helpful=true) or withdraws (helpful=false) the current user's
  /// helpful vote on a review, returning the review's new helpful count.
  Future<int> setHelpful({required String reviewId, required bool helpful}) async {
    final json = helpful
        ? await _client.post('/reviews/$reviewId/helpful')
        : await _client.delete('/reviews/$reviewId/helpful');
    // Both POST and DELETE return {helpful_count, viewer_voted}.
    final count = json['helpful_count'];
    return count is num ? count.toInt() : 0;
  }
}

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  return ReviewsRepository(ref.watch(apiClientProvider));
});
