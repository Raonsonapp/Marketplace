import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../../reviews/presentation/write_review_screen.dart';
import '../application/order_detail_controller.dart';
import '../data/order_models.dart';
import '../data/order_tracking_socket.dart';
import 'widgets/order_status_badge.dart';
import 'widgets/order_tracking_timeline.dart';

/// Order detail screen (`GET /orders/:id` — docs/API_SPEC.md): items, a
/// live-updating status timeline, cancel/reorder actions.
///
/// Tracking: tries `WS /ws/orders/:orderId` for push updates while the
/// screen is open; if that never connects (or drops), falls back to
/// polling `GET /orders/:id` every few seconds — either way the screen
/// stays correct. Both stop once the order reaches a terminal status
/// (delivered/cancelled) or the screen is closed.
class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  late final OrderTrackingSocket _socket;
  Timer? _pollTimer;
  bool _wsConnected = false;

  @override
  void initState() {
    super.initState();
    _socket = OrderTrackingSocket(ref);
    _startTracking();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _socket.disconnect();
    super.dispose();
  }

  void _startTracking() {
    _socket.connect(
      orderId: widget.orderId,
      onStatus: (payload) {
        // The server may push either `{"status": "..."}` or a full order
        // object; either way, the safest, always-correct reaction is a
        // fresh REST fetch rather than trying to patch the local state
        // from a partial payload.
        if (!mounted) return;
        setState(() => _wsConnected = true);
        _stopPollingIfTerminal(payload['status'] as String?);
        ref.read(orderDetailControllerProvider(widget.orderId).notifier).refresh();
      },
      onDone: () {
        if (!mounted) return;
        setState(() => _wsConnected = false);
        _startPollingFallback();
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _wsConnected = false);
        _startPollingFallback();
      },
    );
    // Also arm the polling fallback immediately: if the WebSocket never
    // calls back at all (e.g. connect() hangs on a flaky network), the
    // screen must still refresh itself rather than go stale forever.
    _startPollingFallback();
  }

  void _startPollingFallback() {
    if (_pollTimer != null) return;
    _pollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (_wsConnected) return; // WS is live — no need to also poll.
      ref.read(orderDetailControllerProvider(widget.orderId).notifier).refresh();
    });
  }

  void _stopPollingIfTerminal(String? rawStatus) {
    if (rawStatus == null) return;
    final status = OrderStatus.fromApi(rawStatus);
    if (!status.isActive) {
      _pollTimer?.cancel();
      _pollTimer = null;
      _socket.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = orderDetailControllerProvider(widget.orderId);
    final orderAsync = ref.watch(provider);
    final languageCode = Localizations.localeOf(context).languageCode;

    ref.listen(provider, (previous, next) {
      final order = next.valueOrNull;
      if (order != null) _stopPollingIfTerminal(order.status);
    });

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
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                  child: OrderTrackingTimeline(
                    currentStatus: order.status,
                    isLive: _wsConnected && status.isActive,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.orderItemsTitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('${item.nameSnapshot} ×${item.quantity}'),
                              ),
                              Text(CurrencyFormatter.format(item.totalPrice,
                                  languageCode: languageCode)),
                            ],
                          ),
                          // Only a delivered order's items were actually
                          // received, so only those get a review action —
                          // and it always carries this exact item's real
                          // `order_item_id`, never a guessed one.
                          if (status.isCompleted)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () => context.push(
                                  RoutePaths.writeReview,
                                  extra: WriteReviewRouteArgs(
                                    productId: item.productId,
                                    orderItemId: item.id,
                                    productName: item.nameSnapshot,
                                  ),
                                ),
                                icon: const Icon(LucideIcons.star, size: 16),
                                label: Text(l10n.reviewsLeaveReview),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
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
    await ref.read(orderDetailControllerProvider(widget.orderId).notifier).cancel(reasonController.text);
  }
}
