import 'package:flutter_test/flutter_test.dart';
import 'package:tajikshop/features/loyalty/data/loyalty_models.dart';
import 'package:tajikshop/features/loyalty/presentation/widgets/loyalty_tier_badge.dart';
import 'package:tajikshop/features/loyalty/presentation/widgets/loyalty_transaction_tile.dart';
import 'package:tajikshop/l10n/app_localizations_tg.dart';

void main() {
  final l10n = AppLocalizationsTg();

  group('LoyaltyTransactionType.fromApi', () {
    test('maps every docs/DATABASE_SCHEMA.md CHECK-constraint value', () {
      expect(LoyaltyTransactionType.fromApi('earn'), LoyaltyTransactionType.earn);
      expect(LoyaltyTransactionType.fromApi('spend'), LoyaltyTransactionType.spend);
      expect(LoyaltyTransactionType.fromApi('expire'), LoyaltyTransactionType.expire);
      expect(LoyaltyTransactionType.fromApi('adjust'), LoyaltyTransactionType.adjust);
      expect(LoyaltyTransactionType.fromApi('campaign'), LoyaltyTransactionType.campaign);
    });

    test('falls back to adjust for an unrecognized value rather than throwing', () {
      expect(LoyaltyTransactionType.fromApi('something-new'), LoyaltyTransactionType.adjust);
    });
  });

  group('loyaltyTransactionTypeLabel', () {
    test('returns the matching localized label for every known type', () {
      expect(loyaltyTransactionTypeLabel(l10n, 'earn'), l10n.loyaltyTypeEarn);
      expect(loyaltyTransactionTypeLabel(l10n, 'spend'), l10n.loyaltyTypeSpend);
      expect(loyaltyTransactionTypeLabel(l10n, 'expire'), l10n.loyaltyTypeExpire);
      expect(loyaltyTransactionTypeLabel(l10n, 'adjust'), l10n.loyaltyTypeAdjust);
      expect(loyaltyTransactionTypeLabel(l10n, 'campaign'), l10n.loyaltyTypeCampaign);
    });

    test('falls back to the adjust label for an unrecognized type', () {
      expect(loyaltyTransactionTypeLabel(l10n, 'mystery'), l10n.loyaltyTypeAdjust);
    });
  });

  group('loyaltyTransactionIsCredit', () {
    test('earn and campaign entries are credits', () {
      expect(loyaltyTransactionIsCredit('earn'), isTrue);
      expect(loyaltyTransactionIsCredit('campaign'), isTrue);
    });

    test('spend, expire and adjust entries are not credits', () {
      expect(loyaltyTransactionIsCredit('spend'), isFalse);
      expect(loyaltyTransactionIsCredit('expire'), isFalse);
      expect(loyaltyTransactionIsCredit('adjust'), isFalse);
    });
  });

  group('loyaltyTierLabel', () {
    test('maps every known tier to its localized label', () {
      expect(loyaltyTierLabel(l10n, 'standard'), l10n.loyaltyTierStandard);
      expect(loyaltyTierLabel(l10n, 'gold'), l10n.loyaltyTierGold);
    });

    test('is case-insensitive on the raw tier value', () {
      expect(loyaltyTierLabel(l10n, 'GOLD'), l10n.loyaltyTierGold);
    });

    test('capitalizes an unrecognized tier rather than dropping it', () {
      expect(loyaltyTierLabel(l10n, 'diamond'), 'Diamond');
    });
  });
}
