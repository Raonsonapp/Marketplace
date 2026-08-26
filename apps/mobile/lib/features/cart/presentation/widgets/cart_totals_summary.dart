import 'package:flutter/material.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/cart_models.dart';

/// Renders the cart's subtotal exactly as the server returned it — nothing
/// computed on-device (docs/SECURITY.md: "the client never computes money").
/// Discount, delivery fee, and the final total all depend on a chosen
/// address/delivery method the cart doesn't know yet; those show on the
/// Checkout screen instead, from `POST /checkout/quote`
/// (`CheckoutQuoteSummary`).
class CartTotalsSummary extends StatelessWidget {
  const CartTotalsSummary({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    final formattedSubtotal = CurrencyFormatter.format(cart.subtotal, languageCode: languageCode);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.cartSubtotal, style: theme.textTheme.titleMedium),
              Text(
                formattedSubtotal,
                style: theme.textTheme.titleMedium?.copyWith(color: AppColors.emeraldGreen),
              ),
            ],
          ),
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
