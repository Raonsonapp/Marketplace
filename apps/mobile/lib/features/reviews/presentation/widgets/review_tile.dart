import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/review_models.dart';

/// One review row: rating stars, reviewer name, date, text, any attached
/// images, and a "helpful" vote button (product detail screen —
/// `GET /reviews?product_id=`). [onHelpfulTap] is null for anonymous
/// viewers, who can read the count but not vote.
class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review, this.onHelpfulTap});

  final Review review;
  final VoidCallback? onHelpfulTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  (review.reviewerName == null || review.reviewerName!.isEmpty)
                      ? l10n.reviewsAnonymousReviewer
                      : review.reviewerName!,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              Text(
                DateFormat('d MMM yyyy').format(review.createdAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          RatingStars(rating: review.rating.toDouble(), size: 16),
          if (review.text != null && review.text!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(review.text!, style: theme.textTheme.bodyMedium),
          ],
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xxs),
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                  child: Image.network(
                    review.images[index],
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 64,
                      height: 64,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(LucideIcons.imageOff, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: _HelpfulButton(
              count: review.helpfulCount,
              voted: review.viewerVoted,
              onTap: onHelpfulTap,
              label: l10n.reviewsHelpful,
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpfulButton extends StatelessWidget {
  const _HelpfulButton({
    required this.count,
    required this.voted,
    required this.onTap,
    required this.label,
  });

  final int count;
  final bool voted;
  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = voted ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.heart, size: 16, color: color),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              count > 0 ? '$label · $count' : label,
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
