import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/product.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../../cart/application/cart_controller.dart';
import '../../favorites/application/favorite_ids_controller.dart';
import '../application/product_detail_controller.dart';
import 'widgets/product_gallery.dart';

/// Product detail screen (`GET /products/:id` — docs/API_SPEC.md): gallery,
/// price/old-price/discount, stock status, quantity selector, add-to-cart,
/// favorite toggle, and related products.
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = productDetailControllerProvider(widget.productId);
    final detailAsync = ref.watch(provider);
    final favoriteIds = ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const <String>{};
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: detailAsync.when(
        data: (detail) {
          final product = detail.product.copyWith(isFavorite: favoriteIds.contains(detail.product.id));
          final hasDiscount = product.discountPercent > 0 && product.oldPrice != null;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                actions: [
                  IconButton(
                    icon: Icon(
                      product.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: product.isFavorite ? AppColors.emeraldGreen : null,
                    ),
                    onPressed: () => _toggleFavorite(context, product.id),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductGallery(
                        imageUrls: product.images.isNotEmpty ? product.images : [product.imageUrl],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: AppSpacing.sm,
                        children: [
                          Text(
                            CurrencyFormatter.format(product.price, languageCode: languageCode),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: AppColors.emeraldGreen),
                          ),
                          if (hasDiscount)
                            Text(
                              CurrencyFormatter.format(product.oldPrice!, languageCode: languageCode),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.priceOld,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Icon(
                            product.inStock ? Icons.check_circle_outline : Icons.cancel_outlined,
                            size: 16,
                            color: product.inStock ? AppColors.emeraldGreen : AppColors.error,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            product.inStock ? l10n.productInStock : l10n.productOutOfStock,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: product.inStock ? AppColors.emeraldGreen : AppColors.error,
                                ),
                          ),
                        ],
                      ),
                      if (product.description != null && product.description!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(l10n.productDescription, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(product.description!, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                      if (!product.inStock) ...[
                        const SizedBox(height: AppSpacing.lg),
                        EmptyStateView(
                          icon: Icons.production_quantity_limits,
                          title: l10n.productUnavailableTitle,
                          message: l10n.productUnavailableMessage,
                        ),
                      ],
                      if (detail.related.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(l10n.productRelated, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          height: 230,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: detail.related.length,
                            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                            itemBuilder: (context, index) {
                              final related = detail.related[index];
                              return SizedBox(
                                width: 150,
                                child: ProductCard(
                                  product: related.copyWith(
                                    isFavorite: favoriteIds.contains(related.id),
                                  ),
                                  onTap: () =>
                                      context.push(RoutePaths.productDetailPath(related.id)),
                                  onFavoriteToggle: () => _toggleFavorite(context, related.id),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.read(provider.notifier).refresh(),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonBox(
            width: double.infinity,
            height: 400,
            borderRadius: BorderRadius.all(Radius.circular(AppSpacing.cardRadius)),
          ),
        ),
      ),
      bottomNavigationBar: detailAsync.maybeWhen(
        data: (detail) => detail.product.inStock ? _buildAddToCartBar(context, detail.product) : null,
        orElse: () => null,
      ),
    );
  }

  Widget _buildAddToCartBar(BuildContext context, Product product) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _quantity <= 1 ? null : () => setState(() => _quantity--),
                  ),
                  Text('$_quantity', style: Theme.of(context).textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: PrimaryButton(
                label: l10n.productAddToCart,
                icon: Icons.shopping_cart_outlined,
                onPressed: () => _addToCart(context, product),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context, Product product) async {
    final l10n = AppLocalizations.of(context)!;
    final isAuthenticated =
        ref.read(sessionControllerProvider).valueOrNull?.isAuthenticated ?? false;
    if (!isAuthenticated) {
      context.push(RoutePaths.login);
      return;
    }
    await ref.read(cartControllerProvider.notifier).addItem(
          productId: product.id,
          quantity: _quantity,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.productAddedToCart)));
  }

  Future<void> _toggleFavorite(BuildContext context, String productId) async {
    final isAuthenticated =
        ref.read(sessionControllerProvider).valueOrNull?.isAuthenticated ?? false;
    if (!isAuthenticated) {
      context.push(RoutePaths.login);
      return;
    }
    await ref.read(favoriteIdsControllerProvider.notifier).toggle(productId);
  }
}
