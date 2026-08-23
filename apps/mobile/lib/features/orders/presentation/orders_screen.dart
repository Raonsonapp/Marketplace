import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/orders_controller.dart';
import '../data/orders_repository.dart';
import 'widgets/order_status_badge.dart';

/// The Orders tab: active/completed/cancelled tabs, each backed by
/// `GET /orders?status=` (docs/API_SPEC.md).
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.ordersTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.ordersTabActive),
              Tab(text: l10n.ordersTabCompleted),
              Tab(text: l10n.ordersTabCancelled),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OrdersList(filter: OrdersFilter.active, emptyMessage: l10n.ordersEmptyActive),
            _OrdersList(filter: OrdersFilter.completed, emptyMessage: l10n.ordersEmptyCompleted),
            _OrdersList(filter: OrdersFilter.cancelled, emptyMessage: l10n.ordersEmptyCancelled),
          ],
        ),
      ),
    );
  }
}

class _OrdersList extends ConsumerWidget {
  const _OrdersList({required this.filter, required this.emptyMessage});

  final OrdersFilter filter;
  final String emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final provider = ordersControllerProvider(filter);
    final state = ref.watch(provider);
    final languageCode = Localizations.localeOf(context).languageCode;

    return state.when(
      data: (data) {
        if (data.items.isEmpty) {
          return EmptyStateView(icon: LucideIcons.receipt, title: emptyMessage);
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(provider.notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: data.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final order = data.items[index];
              return InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                onTap: () => context.push(RoutePaths.orderDetailPath(order.id)),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.orderNumber(order.orderNumber),
                              style: Theme.of(context).textTheme.titleSmall),
                          OrderStatusBadge(status: order.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        DateFormat('d MMM yyyy, HH:mm').format(order.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        CurrencyFormatter.format(order.total, languageCode: languageCode),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      error: (error, stackTrace) => ErrorStateView(
        error: error,
        onRetry: () => ref.read(provider.notifier).refresh(),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: ListRowSkeleton(count: 4),
      ),
    );
  }
}
