import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/loyalty_models.dart';

/// Maps a raw ledger-entry type string to its localized label
/// (docs/DATABASE_SCHEMA.md `loyalty_transactions.type`). Pure function —
/// see `test/unit/loyalty_transaction_label_test.dart`.
String loyaltyTransactionTypeLabel(AppLocalizations l10n, String rawType) {
  final type = LoyaltyTransactionType.fromApi(rawType);
  return switch (type) {
    LoyaltyTransactionType.earn => l10n.loyaltyTypeEarn,
    LoyaltyTransactionType.spend => l10n.loyaltyTypeSpend,
    LoyaltyTransactionType.expire => l10n.loyaltyTypeExpire,
    LoyaltyTransactionType.adjust => l10n.loyaltyTypeAdjust,
    LoyaltyTransactionType.campaign => l10n.loyaltyTypeCampaign,
  };
}

/// Whether a ledger entry increases the balance (shown with a `+` sign and
/// the emerald accent) or decreases it (shown with a `-` sign, muted).
bool loyaltyTransactionIsCredit(String rawType) {
  final type = LoyaltyTransactionType.fromApi(rawType);
  return type == LoyaltyTransactionType.earn || type == LoyaltyTransactionType.campaign;
}

IconData loyaltyTransactionIcon(String rawType) {
  final type = LoyaltyTransactionType.fromApi(rawType);
  return switch (type) {
    LoyaltyTransactionType.earn => LucideIcons.plus,
    LoyaltyTransactionType.spend => LucideIcons.minus,
    LoyaltyTransactionType.expire => LucideIcons.clock,
    LoyaltyTransactionType.adjust => LucideIcons.refreshCw,
    LoyaltyTransactionType.campaign => LucideIcons.gift,
  };
}

/// One row in the TajBonus transaction history list.
class LoyaltyTransactionTile extends StatelessWidget {
  const LoyaltyTransactionTile({super.key, required this.transaction});

  final LoyaltyTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final isCredit = loyaltyTransactionIsCredit(transaction.type);
    final sign = isCredit ? '+' : '−';
    final color = isCredit ? AppColors.emeraldGreen : AppColors.textOnLightSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(loyaltyTransactionIcon(transaction.type), size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loyaltyTransactionTypeLabel(l10n, transaction.type),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (transaction.description != null && transaction.description!.isNotEmpty)
                  Text(
                    transaction.description!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  DateFormat('d MMM yyyy, HH:mm').format(transaction.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '$sign ${CurrencyFormatter.format(transaction.amount, languageCode: languageCode)}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
