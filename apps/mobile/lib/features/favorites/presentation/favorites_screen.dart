import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/favorite_ids_controller.dart';
import '../application/favorites_list_controller.dart';

/// Favorites screen (`GET /favorites` — docs/API_SPEC.md). Reachable only
/// while authenticated (router redirect guard).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(favoritesListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: state.when(
        data: (data) {
          if (data.items.isEmpty) {
            return EmptyStateView(
              icon: LucideIcons.heart,
              title: l10n.favoritesEmptyTitle,
              message: l10n.favoritesEmptyMessage,
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(favoritesListControllerProvider.notifier).refresh(),
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: data.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                final product = data.items[index].copyWith(isFavorite: true);
                return ProductCard(
                  product: product,
                  onTap: () => context.push(RoutePaths.productDetailPath(product.id)),
                  onFavoriteToggle: () {
                    ref.read(favoriteIdsControllerProvider.notifier).toggle(product.id);
                    ref.read(favoritesListControllerProvider.notifier).removeLocally(product.id);
                  },
                );
              },
            ),
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.read(favoritesListControllerProvider.notifier).refresh(),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ProductGridSkeleton(),
        ),
      ),
    );
  }
}
