import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand.freezed.dart';
part 'brand.g.dart';

/// A brand, used by the home feed's `featured_brands` section and product
/// filters (see docs/API_SPEC.md).
@freezed
class Brand with _$Brand {
  const factory Brand({
    required String id,
    required String name,
    String? logoUrl,
  }) = _Brand;

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
}
