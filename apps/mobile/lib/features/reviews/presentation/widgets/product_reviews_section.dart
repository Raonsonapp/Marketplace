import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/product_reviews_controller.dart';
import 'product_reviews_list.dart';

/// Product-detail "Reviews" section: loads `GET /reviews?product_id=` for
/// [productId] and renders [ProductReviewsList], with a "see all"/load-more
/// affordance when there are more pages.
class ProductReviewsSection extends ConsumerWidget {
  const ProductReviewsSection({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final provider = productReviewsControllerProvider(productId);
    final reviewsAsync = ref.watch(provider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.reviewsTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        reviewsAsync.when(
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductReviewsList(reviews: data.items),
                if (data.hasMore)
                  Center(
                    child: TextButton(
                      onPressed: data.isLoadingMore
                          ? null
                          : () => ref.read(provider.notifier).loadMore(),
                      child: data.isLoadingMore
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.commonSeeAll),
                    ),
                  ),
              ],
            );
          },
          error: (error, stackTrace) => ErrorStateView(
            error: error,
            onRetry: () => ref.read(provider.notifier).refresh(),
          ),
          loading: () => const ListRowSkeleton(count: 2),
        ),
      ],
    );
  }
}
