import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/models/product.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/region/currency_scope.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';

/// Bottom sheet shown after a successful barcode lookup: name/price/stock
/// status, with a way to go to the full product page or scan again.
class BarcodeResultSheet extends StatelessWidget {
  const BarcodeResultSheet({super.key, required this.product, required this.onScanAgain});

  final Product product;
  final VoidCallback onScanAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final hasDiscount = product.discountPercent > 0 && product.oldPrice != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.barcodeResultTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: product.imageUrl.isEmpty
                        ? Container(color: theme.colorScheme.surfaceContainerHighest)
                        : Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: theme.colorScheme.surfaceContainerHighest),
                          ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: AppSpacing.xxs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            CurrencyFormatter.format(product.price, languageCode: languageCode, currencyLabel: CurrencyScope.labelOf(context)),
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: AppColors.emeraldGreen),
                          ),
                          if (hasDiscount)
                            Text(
                              CurrencyFormatter.format(product.oldPrice!, languageCode: languageCode, currencyLabel: CurrencyScope.labelOf(context)),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.priceOld,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            product.inStock ? LucideIcons.checkCircle : LucideIcons.xCircle,
                            size: 14,
                            color: product.inStock ? AppColors.emeraldGreen : AppColors.error,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            product.inStock ? l10n.productInStock : l10n.productOutOfStock,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: l10n.commonSeeAll,
              onPressed: () {
                context.pop();
                context.push(RoutePaths.productDetailPath(product.id));
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: onScanAgain,
              child: Text(l10n.barcodeScanAgain),
            ),
          ],
        ),
      ),
    );
  }
}
