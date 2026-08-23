import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/promotions_controller.dart';
import '../data/promotion_models.dart';

/// Promotions screen (`GET /promotions` — docs/API_SPEC.md): active
/// campaigns and personal offers. Reachable from Home's "personal offers"
/// section ("see all") and, while authenticated, from Profile.
class PromotionsScreen extends ConsumerWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final promotionsAsync = ref.watch(promotionsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.promotionsTitle)),
      body: promotionsAsync.when(
        data: (promotions) {
          if (promotions.isEmpty) {
            return EmptyStateView(
              icon: LucideIcons.badgePercent,
              title: l10n.promotionsEmptyTitle,
              message: l10n.promotionsEmptyMessage,
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(promotionsControllerProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: promotions.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) => _PromotionCard(promotion: promotions[index]),
            ),
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.read(promotionsControllerProvider.notifier).refresh(),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ListRowSkeleton(count: 4),
        ),
      ),
    );
  }
}

class _PromotionCard extends StatelessWidget {
  const _PromotionCard({required this.promotion});

  final Promotion promotion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final badgeText = promotion.isPercentage
        ? l10n.productDiscountBadge(double.tryParse(promotion.discountValue)?.round() ?? 0)
        : promotion.discountValue;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (promotion.imageUrl != null && promotion.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                  child: Image.network(
                    promotion.imageUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 56,
                      height: 56,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(LucideIcons.badgePercent),
                    ),
                  ),
                )
              else
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.discountBadgeBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                  ),
                  child: const Icon(LucideIcons.badgePercent, color: AppColors.discountBadgeText),
                ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(promotion.title, style: theme.textTheme.titleMedium),
                    if (promotion.description != null && promotion.description!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(promotion.description!, style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.discountBadgeBackground,
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: AppColors.discountBadgeText,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (promotion.endsAt != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(LucideIcons.clock, size: 14),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  l10n.promotionsValidUntil(DateFormat('d MMM yyyy').format(promotion.endsAt!)),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
          if (promotion.promoCode != null && promotion.promoCode!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => _copyCode(context, promotion.promoCode!),
              icon: const Icon(LucideIcons.tag, size: 16),
              label: Text(l10n.promotionsCopyCode(promotion.promoCode!)),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _copyCode(BuildContext context, String code) async {
    final l10n = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.promotionsCodeCopied)));
  }
}
