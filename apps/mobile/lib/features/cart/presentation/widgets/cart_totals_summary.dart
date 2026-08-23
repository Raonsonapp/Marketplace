import 'package:flutter/material.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/cart_models.dart';

/// Renders exactly what the server returned for the cart totals —
/// subtotal/discount/delivery fee/total — and nothing computed on-device
/// (docs/SECURITY.md: "the client never computes money").
class CartTotalsSummary extends StatelessWidget {
  const CartTotalsSummary({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    Widget row(String label, String amount, {bool isTotal = false, bool isDiscount = false}) {
      final formatted = CurrencyFormatter.format(amount, languageCode: languageCode);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: isTotal ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium,
            ),
            Text(
              isDiscount ? '-$formatted' : formatted,
              style: isTotal
                  ? theme.textTheme.titleMedium?.copyWith(color: AppColors.emeraldGreen)
                  : theme.textTheme.bodyMedium?.copyWith(
                      color: isDiscount ? AppColors.emeraldGreen : null,
                    ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          row(l10n.cartSubtotal, cart.subtotal),
          if (double.tryParse(cart.discount) != null && double.parse(cart.discount) > 0)
            row(l10n.cartDiscount, cart.discount, isDiscount: true),
          row(l10n.cartDeliveryFee, cart.deliveryFee),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Divider(),
          ),
          row(l10n.cartTotal, cart.total, isTotal: true),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(LucideIcons.shieldCheck, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(
                child: Text(
                  l10n.cartServerCalculatedNote,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
