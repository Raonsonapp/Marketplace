import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// A catalog product as returned by `/home`, `/categories/:id/products`,
/// `/products`, `/products/:id`, `/search`, cart items, order items, and
/// favorites (see docs/API_SPEC.md). Money fields are decimal strings, never
/// floats, and are rendered only via [CurrencyFormatter] — the client never
/// computes prices (see docs/SECURITY.md).
@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    String? description,
    required String imageUrl,
    @Default(<String>[]) List<String> images,
    required String price,
    String? oldPrice,
    @Default(0) int discountPercent,
    @Default(0.0) double ratingAvg,
    @Default(0) int ratingCount,
    @Default(true) bool inStock,
    int? stockQuantity,
    String? categoryId,
    String? brandId,
    String? brandName,
    String? storeId,
    @Default('pcs') String unit,
    @Default(false) bool isFavorite,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

/// Full product detail payload from `GET /products/:id`, extending the
/// catalog card with related/similar items. Parsed manually (see
/// `product_repository.dart`) since the API returns the product fields
/// flattened alongside a `related` array rather than nested.
@freezed
abstract class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required Product product,
    @Default(<Product>[]) List<Product> related,
  }) = _ProductDetail;
}
