import 'package:flutter/material.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/currency_formatter.dart';
import 'rating_stars.dart';

/// The single product-card component used by every product grid/row in the
/// app (home sections, catalog, search results, favorites, "buy again").
/// Shows image, name, price/old-price, a discount badge when applicable,
/// and a favorite toggle — per docs/ARCHITECTURE.md's shared-widgets rule.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavoriteToggle,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final hasDiscount = product.discountPercent > 0 && product.oldPrice != null;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: product.imageUrl.isEmpty
                        ? const Icon(LucideIcons.image, size: 32)
                        : Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(LucideIcons.imageOff, size: 32),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: AppSpacing.xs,
                    left: AppSpacing.xs,
                    child: _DiscountBadge(percent: product.discountPercent),
                  ),
                Positioned(
                  top: AppSpacing.xxs,
                  right: AppSpacing.xxs,
                  child: _FavoriteButton(
                    isFavorite: product.isFavorite,
                    onTap: onFavoriteToggle,
                  ),
                ),
                if (!product.inStock)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          if (product.ratingCount > 0) ...[
            const SizedBox(height: AppSpacing.xxs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingStars(rating: product.ratingAvg, size: 12),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '${product.ratingAvg.toStringAsFixed(1)} (${product.ratingCount})',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.xxs),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.xs,
            children: [
              Text(
                CurrencyFormatter.format(product.price, languageCode: languageCode),
                style: theme.textTheme.titleSmall?.copyWith(color: AppColors.emeraldGreen),
              ),
              if (hasDiscount)
                Text(
                  CurrencyFormatter.format(product.oldPrice!, languageCode: languageCode),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.priceOld,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.discountBadgeBackground,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(
        '-$percent%',
        style: const TextStyle(
          color: AppColors.discountBadgeText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, this.onTap});

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return const SizedBox.shrink();
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            isFavorite ? LucideIcons.heart : LucideIcons.heart,
            size: 18,
            color: isFavorite ? AppColors.neonGreenHighlight : Colors.white,
          ),
        ),
      ),
    );
  }
}
