// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  rating: (json['rating'] as num).toInt(),
  text: json['text'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: DateTime.parse(json['created_at'] as String),
  reviewerName: json['reviewer_name'] as String?,
  helpfulCount: (json['helpful_count'] as num?)?.toInt() ?? 0,
  viewerVoted: json['viewer_voted'] as bool? ?? false,
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'rating': instance.rating,
  'text': ?instance.text,
  'images': instance.images,
  'created_at': instance.createdAt.toIso8601String(),
  'reviewer_name': ?instance.reviewerName,
  'helpful_count': instance.helpfulCount,
  'viewer_voted': instance.viewerVoted,
};
