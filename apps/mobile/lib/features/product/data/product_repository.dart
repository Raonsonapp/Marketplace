import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/product.dart';
import '../../../core/network/api_client.dart';

/// Calls `/products/:id` and `/products/barcode/:code` (docs/API_SPEC.md).
class ProductRepository {
  ProductRepository(this._client);

  final ApiClient _client;

  Future<ProductDetail> getProductDetail(String productId) async {
    final json = await _client.get('/products/$productId');
    return _parseProductDetail(json);
  }

  Future<ProductDetail> getProductByBarcode(String barcode) async {
    final json = await _client.get('/products/barcode/$barcode');
    return _parseProductDetail(json);
  }

  /// The API returns the product's own fields flattened at the top level
  /// alongside a `related`/`similar` array (docs/API_SPEC.md: "full product
  /// detail incl. related/similar").
  ProductDetail _parseProductDetail(Map<String, dynamic> json) {
    final product = Product.fromJson(json);
    final relatedJson = (json['related'] as List<dynamic>?) ??
        (json['similar'] as List<dynamic>?) ??
        const [];
    return ProductDetail(
      product: product,
      related: relatedJson.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(apiClientProvider));
});
