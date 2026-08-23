import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/category.dart';
import '../data/catalog_repository.dart';

/// Loads the category tree for the Catalog tab (`GET /categories`).
class CategoriesController extends AsyncNotifier<List<Category>> {
  @override
  Future<List<Category>> build() {
    return ref.watch(catalogRepositoryProvider).getCategories();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<Category>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(catalogRepositoryProvider).getCategories());
  }
}

final categoriesControllerProvider =
    AsyncNotifierProvider<CategoriesController, List<Category>>(CategoriesController.new);
