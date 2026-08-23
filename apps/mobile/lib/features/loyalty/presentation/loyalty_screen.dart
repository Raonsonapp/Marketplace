import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/loyalty_account_controller.dart';
import '../application/loyalty_transactions_controller.dart';
import '../data/loyalty_models.dart';
import 'widgets/loyalty_tier_badge.dart';
import 'widgets/loyalty_transaction_tile.dart';

/// TajBonus screen (`GET /loyalty`, `GET /loyalty/transactions` —
/// docs/API_SPEC.md, brief Section 15): balance/tier/lifetime-earned
/// header plus a paginated transaction ledger. Reachable only while
/// authenticated (router redirect guard).
class LoyaltyScreen extends ConsumerStatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  ConsumerState<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends ConsumerState<LoyaltyScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      ref.read(loyaltyTransactionsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accountAsync = ref.watch(loyaltyAccountControllerProvider);
    final transactionsAsync = ref.watch(loyaltyTransactionsControllerProvider);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loyaltyTitle)),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(loyaltyAccountControllerProvider.notifier).refresh(),
            ref.read(loyaltyTransactionsControllerProvider.notifier).refresh(),
          ]);
        },
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            accountAsync.when(
              data: (account) => _AccountHeader(account: account, languageCode: languageCode),
              error: (error, stackTrace) => ErrorStateView(
                error: error,
                onRetry: () => ref.read(loyaltyAccountControllerProvider.notifier).refresh(),
              ),
              loading: () => const SkeletonBox(
                width: double.infinity,
                height: 140,
                borderRadius: BorderRadius.all(Radius.circular(AppSpacing.cardRadius)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.loyaltyTransactionsTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            transactionsAsync.when(
              data: (data) {
                if (data.items.isEmpty) {
                  return EmptyStateView(
                    icon: LucideIcons.coins,
                    title: l10n.loyaltyEmptyTransactionsTitle,
                    message: l10n.loyaltyEmptyTransactionsMessage,
                  );
                }
                return Column(
                  children: [
                    ...data.items.map((tx) => LoyaltyTransactionTile(transaction: tx)),
                    if (data.isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              },
              error: (error, stackTrace) => ErrorStateView(
                error: error,
                onRetry: () => ref.read(loyaltyTransactionsControllerProvider.notifier).refresh(),
              ),
              loading: () => const ListRowSkeleton(count: 5),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.account, required this.languageCode});

  final LoyaltyAccount account;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.coins, color: Colors.white),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    l10n.loyaltyBalance,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              LoyaltyTierBadge(tier: account.tier),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            CurrencyFormatter.format(account.balance, languageCode: languageCode),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.loyaltyLifetimeEarned(
              CurrencyFormatter.format(account.lifetimeEarned, languageCode: languageCode),
            ),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
