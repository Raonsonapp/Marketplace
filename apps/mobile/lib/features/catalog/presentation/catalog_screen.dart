import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/categories_controller.dart';

/// The Catalog tab — a grid of top-level categories
/// (`GET /categories` — docs/API_SPEC.md).
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  /// Cycled by category index when a category has no `iconUrl` (the seed
  /// catalog doesn't set one yet) — varied icons on a brand-gradient circle
  /// read as noticeably more "designed" than one repeated placeholder icon,
  /// without needing real category photography this session has no way to
  /// source.
  static const _categoryIcons = [
    LucideIcons.shoppingBag,
    LucideIcons.gift,
    LucideIcons.package,
    LucideIcons.store,
    LucideIcons.badgePercent,
    LucideIcons.coins,
    LucideIcons.heart,
    LucideIcons.star,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(categoriesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.catalogTitle),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () => context.push(RoutePaths.search),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return EmptyStateView(
              title: l10n.catalogEmptyCategories,
              actionLabel: l10n.commonRetry,
              onAction: () => ref.read(categoriesControllerProvider.notifier).refresh(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(categoriesControllerProvider.notifier).refresh(),
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  onTap: () => context.push(
                    '${RoutePaths.categoryProductsPath(category.id)}?name=${Uri.encodeComponent(category.name)}',
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: category.iconUrl == null || category.iconUrl!.isEmpty
                              ? Icon(
                                  _categoryIcons[index % _categoryIcons.length],
                                  color: Colors.white,
                                  size: 26,
                                )
                              : ClipOval(
                                  child: Image.network(
                                    category.iconUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      _categoryIcons[index % _categoryIcons.length],
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.read(categoriesControllerProvider.notifier).refresh(),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ProductGridSkeleton(itemCount: 9, crossAxisCount: 3),
        ),
      ),
    );
  }
}
