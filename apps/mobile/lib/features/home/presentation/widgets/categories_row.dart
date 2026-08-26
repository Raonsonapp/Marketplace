import 'package:flutter/material.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/models/category.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/section_header.dart';

/// A horizontal row of category shortcuts on the home feed.
class CategoriesRow extends StatelessWidget {
  const CategoriesRow({
    super.key,
    required this.title,
    required this.categories,
    required this.onCategoryTap,
  });

  final String title;
  final List<Category> categories;
  final void Function(Category category) onCategoryTap;

  /// Cycled by index when a category has no `iconUrl` (the seed catalog
  /// doesn't set one) — varied icons on a brand-gradient circle read as
  /// designed imagery rather than one repeated gray placeholder, matching
  /// the Catalog tab's treatment.
  static const _icons = [
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
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => onCategoryTap(category),
                child: SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: category.iconUrl == null || category.iconUrl!.isEmpty
                            ? Icon(
                                _icons[index % _icons.length],
                                color: Colors.white,
                                size: 26,
                              )
                            : ClipOval(
                                child: Image.network(
                                  category.iconUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    _icons[index % _icons.length],
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        category.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
