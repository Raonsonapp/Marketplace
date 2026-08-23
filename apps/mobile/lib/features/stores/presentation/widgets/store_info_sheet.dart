import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/models/store.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/store_sample_products_controller.dart';

/// Bottom sheet shown when tapping a store marker on the nearby-stores map:
/// name, address, distance, delivery/pickup availability, and a few sample
/// products so the user can tell what the store actually carries.
class StoreInfoSheet extends ConsumerWidget {
  const StoreInfoSheet({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final sampleProducts = ref.watch(storeSampleProductsProvider(store.id));

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                  ),
                  child: store.logoUrl == null || store.logoUrl!.isEmpty
                      ? const Icon(LucideIcons.store)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                          child: Image.network(
                            store.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(LucideIcons.store),
                          ),
                        ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name, style: theme.textTheme.titleMedium),
                      if (store.address != null)
                        Text(
                          store.address!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                if (store.distanceKm != null)
                  _InfoChip(
                    icon: LucideIcons.mapPin,
                    label: l10n.storeDistanceAway(store.distanceKm!.toStringAsFixed(1)),
                  ),
                if (store.isDeliveryAvailable)
                  _InfoChip(icon: LucideIcons.truck, label: l10n.storeDeliveryAvailable),
                if (store.isPickupAvailable)
                  _InfoChip(icon: LucideIcons.shoppingBag, label: l10n.storePickupAvailable),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.storeSells, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            sampleProducts.when(
              data: (products) {
                if (products.isEmpty) return const SizedBox.shrink();
                return Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: products
                      .map((p) => Chip(
                            label: Text(p.name, overflow: TextOverflow.ellipsis),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                );
              },
              error: (error, stackTrace) => const SizedBox.shrink(),
              loading: () => const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.pop();
                  context.go(RoutePaths.catalog);
                },
                icon: const Icon(LucideIcons.layoutGrid, size: 18),
                label: Text(l10n.storeBrowseCatalog),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.emeraldGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.emeraldGreen),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.emeraldGreen)),
        ],
      ),
    );
  }
}
