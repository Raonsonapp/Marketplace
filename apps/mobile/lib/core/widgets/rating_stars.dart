import 'package:flutter/material.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../theme/app_colors.dart';

/// A row of 5 star icons. Read-only when [onChanged] is null (product
/// cards, review tiles); tappable to pick a 1-5 rating when [onChanged] is
/// set (the "write a review" form).
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.onChanged,
    this.size = 20,
  });

  /// Current rating, 0-5. Fractional values (e.g. a product's average)
  /// round to the nearest whole star for display.
  final double rating;
  final ValueChanged<int>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final rounded = rating.round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rounded;
        final star = Icon(
          LucideIcons.star,
          size: size,
          color: filled ? AppColors.warning : AppColors.priceOld,
        );
        if (onChanged == null) return star;
        return InkWell(
          borderRadius: BorderRadius.circular(size),
          onTap: () => onChanged!(index + 1),
          child: Padding(padding: const EdgeInsets.all(2), child: star),
        );
      }),
    );
  }
}
