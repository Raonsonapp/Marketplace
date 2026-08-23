import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/order_detail_controller.dart';
import '../data/order_models.dart';
import 'widgets/order_status_badge.dart';

/// Order detail screen (`GET /orders/:id` — docs/API_SPEC.md): items,
/// status history, cancel/reorder actions.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final provider = orderDetailControllerProvider(orderId);
    final orderAsync = ref.watch(provider);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderDetailTitle)),
      body: orderAsync.when(
        data: (order) {
          final status = OrderStatus.fromApi(order.status);
          return RefreshIndicator(
            onRefresh: () => ref.read(provider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.orderNumber(order.orderNumber),
                        style: Theme.of(context).textTheme.headlineSmall),
                    OrderStatusBadge(status: order.status),
                  ],
                ),
                Text(
                  DateFormat('d MMM yyyy, HH:mm').format(order.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.orderItemsTitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('${item.nameSnapshot} ×${item.quantity}'),
                          ),
                          Text(CurrencyFormatter.format(item.totalPrice, languageCode: languageCode)),
                        ],
                      ),
                    )),
                const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.sm), child: Divider()),
                _totalsRow(context, l10n.cartSubtotal, order.subtotal),
                if (double.tryParse(order.discountAmount) != null && double.parse(order.discountAmount) > 0)
                  _totalsRow(context, l10n.cartDiscount, order.discountAmount),
                _totalsRow(context, l10n.cartDeliveryFee, order.deliveryFee),
                _totalsRow(context, l10n.cartTotal, order.total, isTotal: true),
                if (order.statusHistory.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(l10n.orderStatusHistory, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  ...order.statusHistory.map((event) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                        child: Row(
                          children: [
                            Icon(LucideIcons.circle, size: 8, color: orderStatusColor(event.status)),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(child: Text(orderStatusLabel(l10n, event.status))),
                            Text(
                              DateFormat('d MMM, HH:mm').format(event.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      )),
                ],
                const SizedBox(height: AppSpacing.xl),
                if (status.isActive)
                  OutlinedButton(
                    onPressed: () => _showCancelDialog(context, ref),
                    child: Text(l10n.orderCancel),
                  ),
                if (status.isCompleted || status.isCancelled) ...[
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: l10n.orderReorder,
                    onPressed: () async {
                      await ref.read(provider.notifier).reorder();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(l10n.productAddedToCart)));
                      }
                    },
                  ),
                ],
              ],
            ),
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.read(provider.notifier).refresh(),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ListRowSkeleton(count: 3),
        ),
      ),
    );
  }

  Widget _totalsRow(BuildContext context, String label, String amount, {bool isTotal = false}) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? Theme.of(context).textTheme.titleMedium : null),
          Text(
            CurrencyFormatter.format(amount, languageCode: languageCode),
            style: isTotal
                ? Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.emeraldGreen)
                : null,
          ),
        ],
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.orderCancel),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(hintText: l10n.orderCancelReasonHint),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(orderDetailControllerProvider(orderId).notifier).cancel(reasonController.text);
  }
}
