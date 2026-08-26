import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_models.freezed.dart';
part 'review_models.g.dart';

/// One approved product review (`GET /reviews?product_id=` —
/// docs/API_SPEC.md), backed by the `reviews`/`review_images` tables
/// (docs/DATABASE_SCHEMA.md). `reviewerName` is the purchasing user's
/// display name, joined server-side — reviews never expose the reviewer's
/// phone/id to other users.
@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    required String productId,
    required int rating,
    String? text,
    @Default(<String>[]) List<String> images,
    required DateTime createdAt,
    String? reviewerName,
    @Default(0) int helpfulCount,
    @Default(false) bool viewerVoted,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
