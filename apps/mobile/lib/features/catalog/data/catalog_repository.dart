import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/models/category.dart';
import '../../../core/models/paginated_response.dart';
import '../../../core/models/product.dart';
import '../../../core/network/api_client.dart';

/// Sort orders accepted by `GET /products` (docs/API_SPEC.md).
enum ProductSort { popular, priceAsc, priceDesc, rating, discount, newest }

extension on ProductSort {
  String get apiValue => switch (this) {
        ProductSort.popular => 'popular',
        ProductSort.priceAsc => 'price_asc',
        ProductSort.priceDesc => 'price_desc',
        ProductSort.rating => 'rating',
        ProductSort.discount => 'discount',
        ProductSort.newest => 'newest',
      };
}

/// Calls `/categories*` and `/products*` (see docs/API_SPEC.md).
class CatalogRepository {
  CatalogRepository(this._client);

  final ApiClient _client;

  Future<List<Category>> getCategories() async {
    // GET /categories wraps its array in {"data": [...]} (see
    // CatalogHandler.Categories), not a bare JSON array — use `get`, not
    // `getRaw`, so this matches that shape instead of throwing a cast
    // error the moment the response is a Map.
    final json = await _client.get('/categories');
    final list = (json['data'] as List<dynamic>?) ?? const [];
    return list.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PaginatedResponse<Product>> getCategoryProducts(
    String categoryId, {
    String? cursor,
    int limit = AppConstants.defaultPageSize,
  }) async {
    final json = await _client.get('/categories/$categoryId/products', queryParameters: {
      'limit': limit,
      'cursor': ?cursor,
    });
    return PaginatedResponse.fromJson(json, Product.fromJson);
  }

  Future<PaginatedResponse<Product>> getProducts({
    String? cursor,
    int limit = AppConstants.defaultPageSize,
    String? categoryId,
    String? brandId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? hasDiscount,
    String? storeId,
    bool? inStock,
    ProductSort sort = ProductSort.popular,
  }) async {
    final json = await _client.get('/products', queryParameters: {
      'limit': limit,
      'sort': sort.apiValue,
      'cursor': ?cursor,
      'category_id': ?categoryId,
      'brand_id': ?brandId,
      'min_price': ?minPrice,
      'max_price': ?maxPrice,
      'min_rating': ?minRating,
      'has_discount': ?hasDiscount,
      'store_id': ?storeId,
      'in_stock': ?inStock,
    });
    return PaginatedResponse.fromJson(json, Product.fromJson);
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(ref.watch(apiClientProvider));
});
