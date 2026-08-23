import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/order_models.dart';

/// Maps a raw order-status string to its localized label
/// (docs/DATABASE_SCHEMA.md `orders.status`).
String orderStatusLabel(AppLocalizations l10n, String rawStatus) {
  final status = OrderStatus.fromApi(rawStatus);
  return switch (status) {
    OrderStatus.pending => l10n.orderStatusPending,
    OrderStatus.confirmed => l10n.orderStatusConfirmed,
    OrderStatus.preparing => l10n.orderStatusPreparing,
    OrderStatus.ready => l10n.orderStatusReady,
    OrderStatus.courierAssigned => l10n.orderStatusCourierAssigned,
    OrderStatus.pickedUp => l10n.orderStatusPickedUp,
    OrderStatus.delivering => l10n.orderStatusDelivering,
    OrderStatus.delivered => l10n.orderStatusDelivered,
    OrderStatus.cancelled => l10n.orderStatusCancelled,
  };
}

Color orderStatusColor(String rawStatus) {
  final status = OrderStatus.fromApi(rawStatus);
  if (status.isCancelled) return AppColors.error;
  if (status.isCompleted) return AppColors.emeraldGreen;
  return AppColors.info;
}

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = orderStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(
        orderStatusLabel(l10n, status),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
