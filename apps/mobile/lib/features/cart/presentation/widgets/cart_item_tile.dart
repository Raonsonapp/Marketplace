import 'package:flutter/material.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/cart_models.dart';

/// One row in the cart list: image, name, unit price, quantity stepper,
/// remove/save-for-later actions, and the server-computed line total.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    this.onSaveForLater,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final VoidCallback? onSaveForLater;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Opacity(
      opacity: item.isAvailable ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
              child: SizedBox(
                width: 72,
                height: 72,
                child: item.product.imageUrl.isEmpty
                    ? Container(color: theme.colorScheme.surfaceContainerHighest)
                    : Image.network(
                        item.product.imageUrl,
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
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (!item.isAvailable)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        l10n.productOutOfStock,
                        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _QuantityStepper(
                        quantity: item.quantity,
                        onChanged: item.isAvailable ? onQuantityChanged : null,
                      ),
                      Text(
                        CurrencyFormatter.format(item.lineTotal, languageCode: languageCode),
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (onSaveForLater != null)
                        TextButton(
                          onPressed: onSaveForLater,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(l10n.cartSaveForLater, style: theme.textTheme.labelMedium),
                        ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(LucideIcons.trash2, size: 20),
                        onPressed: onRemove,
                        tooltip: l10n.cartRemoveItem,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, this.onChanged});

  final int quantity;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(LucideIcons.minus, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: onChanged == null || quantity <= 1 ? null : () => onChanged!(quantity - 1),
          ),
          SizedBox(
            width: 24,
            child: Text('$quantity', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          ),
          IconButton(
            icon: const Icon(LucideIcons.plus, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: onChanged == null ? null : () => onChanged!(quantity + 1),
          ),
        ],
      ),
    );
  }
}
