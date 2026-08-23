import 'package:flutter/material.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/models/brand.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/section_header.dart';

/// A horizontal row of featured brand logos on the home feed.
class FeaturedBrandsRow extends StatelessWidget {
  const FeaturedBrandsRow({super.key, required this.title, required this.brands});

  final String title;
  final List<Brand> brands;

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: brands.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                ),
                child: brand.logoUrl == null || brand.logoUrl!.isEmpty
                    ? const Icon(LucideIcons.tag)
                    : Image.network(
                        brand.logoUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(LucideIcons.tag),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
