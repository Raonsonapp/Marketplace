import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// Maps `loyalty_accounts.tier` (docs/DATABASE_SCHEMA.md — an open-ended
/// `varchar(20)`, not a fixed enum) to a localized label, falling back to
/// the raw value capitalized for a tier name the client doesn't
/// specifically recognize yet.
String loyaltyTierLabel(AppLocalizations l10n, String rawTier) {
  return switch (rawTier.toLowerCase()) {
    'standard' => l10n.loyaltyTierStandard,
    'silver' => l10n.loyaltyTierSilver,
    'gold' => l10n.loyaltyTierGold,
    'platinum' => l10n.loyaltyTierPlatinum,
    _ => rawTier.isEmpty ? rawTier : '${rawTier[0].toUpperCase()}${rawTier.substring(1)}',
  };
}

class LoyaltyTierBadge extends StatelessWidget {
  const LoyaltyTierBadge({super.key, required this.tier});

  final String tier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.discountBadgeBackground,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Text(
        loyaltyTierLabel(l10n, tier),
        style: const TextStyle(
          color: AppColors.discountBadgeText,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
