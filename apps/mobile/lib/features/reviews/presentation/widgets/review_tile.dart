import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/review_models.dart';

/// One review row: rating stars, reviewer name, date, text, and any
/// attached images (product detail screen — `GET /reviews?product_id=`).
class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});

  final Review review;

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
        ],
      ),
    );
  }
}
