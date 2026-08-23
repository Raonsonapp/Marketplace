import 'package:flutter/material.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/review_models.dart';
import 'review_tile.dart';

/// Renders a product's review list, or an explicit empty state when there
/// are none yet — a plain data-in widget (no Riverpod dependency) so it is
/// straightforward to widget-test in isolation
/// (see `test/widget/product_reviews_list_test.dart`).
class ProductReviewsList extends StatelessWidget {
  const ProductReviewsList({super.key, required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (reviews.isEmpty) {
      return EmptyStateView(
        icon: LucideIcons.star,
        title: l10n.reviewsEmptyTitle,
        message: l10n.reviewsEmptyMessage,
      );
    }
    return Column(
      children: [
        for (var i = 0; i < reviews.length; i++) ...[
          ReviewTile(review: reviews[i]),
          if (i < reviews.length - 1) const Divider(height: AppSpacing.xs),
        ],
      ],
    );
  }
}
