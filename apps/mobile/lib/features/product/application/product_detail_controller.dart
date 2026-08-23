import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/product_repository.dart';
import '../../../core/models/product.dart';

/// Loads a single product's detail (`GET /products/:id` —
/// docs/API_SPEC.md), keyed by product id.
class ProductDetailController extends FamilyAsyncNotifier<ProductDetail, String> {
  @override
  Future<ProductDetail> build(String arg) {
    return ref.watch(productRepositoryProvider).getProductDetail(arg);
  }

  Future<void> refresh() async {
    final id = arg;
    state = const AsyncLoading<ProductDetail>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(productRepositoryProvider).getProductDetail(id));
  }
}

final productDetailControllerProvider =
    AsyncNotifierProvider.family<ProductDetailController, ProductDetail, String>(
        ProductDetailController.new);
