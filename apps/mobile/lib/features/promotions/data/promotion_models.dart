import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_models.freezed.dart';
part 'promotion_models.g.dart';

/// One active campaign / personal offer from `GET /promotions`
/// (docs/API_SPEC.md), backed by the `discounts` table
/// (docs/DATABASE_SCHEMA.md: personal/category/product/campaign offers).
/// `title`/`description` arrive already localized server-side (Accept-
/// Language), matching every other bilingual field in the app (see
/// `BannerItem`).
@freezed
abstract class Promotion with _$Promotion {
  const factory Promotion({
    required String id,
    required String title,
    String? description,
    String? imageUrl,
    // 'percentage' | 'fixed' (docs/DATABASE_SCHEMA.md `discounts.discount_type`).
    required String discountType,
    required String discountValue,
    DateTime? startsAt,
    DateTime? endsAt,
    String? promoCode,
  }) = _Promotion;

  const Promotion._();

  factory Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);

  bool get isPercentage => discountType == 'percentage';
}
