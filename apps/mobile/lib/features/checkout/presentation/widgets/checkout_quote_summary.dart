import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/checkout_models.dart';

/// Renders the server-computed checkout quote (`POST /checkout/quote`) —
/// never a client-side recomputation (docs/SECURITY.md).
class CheckoutQuoteSummary extends StatelessWidget {
  const CheckoutQuoteSummary({super.key, required this.quote});

  final CheckoutQuote quote;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    Widget row(String label, String amount, {bool isTotal = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: isTotal ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium),
            Text(
              CurrencyFormatter.format(amount, languageCode: languageCode),
              style: isTotal
                  ? theme.textTheme.titleMedium?.copyWith(color: AppColors.emeraldGreen)
                  : theme.textTheme.bodyMedium,
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
          row(l10n.cartSubtotal, quote.subtotal),
          if (double.tryParse(quote.discount) != null && double.parse(quote.discount) > 0)
            row(l10n.cartDiscount, quote.discount),
          row(l10n.cartDeliveryFee, quote.deliveryFee),
          const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.xs), child: Divider()),
          row(l10n.cartTotal, quote.total, isTotal: true),
        ],
      ),
    );
  }
}
