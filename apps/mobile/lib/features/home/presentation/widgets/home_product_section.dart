import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/product.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../favorites/application/favorite_ids_controller.dart';

/// A horizontally scrolling row of [ProductCard]s under a [SectionHeader],
/// used for every product-based home-feed section (popular, discounted,
/// recommended, recently viewed, personal offers, buy again).
class HomeProductSection extends ConsumerWidget {
  const HomeProductSection({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
    this.onSeeAll,
  });

  final String title;
  final List<Product> products;
  final void Function(Product product) onProductTap;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (products.isEmpty) return const SizedBox.shrink();
    final favoriteIds = ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const <String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, onSeeAll: onSeeAll),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 236,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final product = products[index].copyWith(
                isFavorite: favoriteIds.contains(products[index].id),
              );
              return SizedBox(
                width: 150,
                child: ProductCard(
                  product: product,
                  onTap: () => onProductTap(product),
                  onFavoriteToggle: () =>
                      ref.read(favoriteIdsControllerProvider.notifier).toggle(product.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
