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
    @Default(<String>[]) List<String> images,
    required String price,
    String? oldPrice,
    @Default(0.0) @JsonKey(fromJson: _ratingFromJson) double ratingAvg,
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

  const Product._();

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  /// The backend (`docs/API_SPEC.md`) never sends a single `image_url` —
  /// only an `images` array — so this is derived rather than parsed.
  String get imageUrl => images.isNotEmpty ? images.first : '';

  /// discount_percent isn't sent by the backend either; derive it from
  /// price/oldPrice (both decimal strings — see docs/SECURITY.md on why the
  /// client never does money arithmetic with floats for anything that
  /// affects a real total, which display-only rounding here does not).
  int get discountPercent {
    final old = oldPrice;
    if (old == null) return 0;
    final oldValue = double.tryParse(old);
    final newValue = double.tryParse(price);
    if (oldValue == null || newValue == null || oldValue <= 0 || newValue >= oldValue) return 0;
    return (((oldValue - newValue) / oldValue) * 100).round();
  }
}

/// The backend sends `rating_avg` as a decimal string (e.g. "4.5"), not a
/// JSON number — see `services/api/internal/httpapi/dto/catalog.go`.
double _ratingFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
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
