import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/product.dart';
import '../../catalog/data/catalog_repository.dart';

/// A handful of sample products for one store, used to answer "what does
/// this store carry?" in the nearby-stores map info sheet — reuses
/// `GET /products?store_id=` (docs/API_SPEC.md) rather than a dedicated
/// endpoint; a few items are enough, this is not meant to be exhaustive.
final storeSampleProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, storeId) async {
  final page = await ref.watch(catalogRepositoryProvider).getProducts(
        storeId: storeId,
        limit: 6,
      );
  return page.data;
});
