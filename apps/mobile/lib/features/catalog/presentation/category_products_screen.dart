import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../../favorites/application/favorite_ids_controller.dart';
import '../application/category_products_controller.dart';

/// Paginated product grid for one category
/// (`GET /categories/:id/products` — docs/API_SPEC.md).
class CategoryProductsScreen extends ConsumerStatefulWidget {
  const CategoryProductsScreen({super.key, required this.categoryId, this.categoryName});

  final String categoryId;
  final String? categoryName;

  @override
  ConsumerState<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends ConsumerState<CategoryProductsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      ref.read(categoryProductsControllerProvider(widget.categoryId).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = categoryProductsControllerProvider(widget.categoryId);
    final state = ref.watch(provider);
    final favoriteIds = ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const <String>{};

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName ?? l10n.catalogTitle)),
      body: state.when(
        data: (data) {
          if (data.items.isEmpty) {
            return EmptyStateView(title: l10n.categoryProductsEmpty);
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(provider.notifier).refresh(),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: data.items.length + (data.hasMore ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                if (index >= data.items.length) {
                  return const Center(child: ProductCardSkeleton());
                }
                final product = data.items[index].copyWith(
                  isFavorite: favoriteIds.contains(data.items[index].id),
                );
                return ProductCard(
                  product: product,
                  onTap: () => context.push(RoutePaths.productDetailPath(product.id)),
                  onFavoriteToggle: () =>
                      ref.read(favoriteIdsControllerProvider.notifier).toggle(product.id),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.read(provider.notifier).refresh(),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ProductGridSkeleton(),
        ),
      ),
    );
  }
}
