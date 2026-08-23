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
}

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  return ReviewsRepository(ref.watch(apiClientProvider));
});
