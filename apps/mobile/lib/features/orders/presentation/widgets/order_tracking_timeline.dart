import 'package:flutter/material.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/order_models.dart';
import 'order_status_badge.dart';

/// The full, non-cancelled order lifecycle in display order (see
/// docs/DATABASE_SCHEMA.md `orders.status`).
const List<OrderStatus> _lifecycle = [
  OrderStatus.pending,
  OrderStatus.confirmed,
  OrderStatus.preparing,
  OrderStatus.ready,
  OrderStatus.courierAssigned,
  OrderStatus.pickedUp,
  OrderStatus.delivering,
  OrderStatus.delivered,
];

/// A vertical stepper visualizing where an order sits in its lifecycle —
/// done / current / upcoming stages — with `cancelled` rendered as a
/// distinct terminal branch rather than a step on the happy path.
class OrderTrackingTimeline extends StatelessWidget {
  const OrderTrackingTimeline({super.key, required this.currentStatus, this.isLive = false});

  final String currentStatus;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = OrderStatus.fromApi(currentStatus);

    if (status.isCancelled) {
      return _CancelledBanner(l10n: l10n);
    }

    final currentIndex = _lifecycle.indexOf(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.orderTrackingTitle, style: Theme.of(context).textTheme.titleMedium),
            if (isLive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _PulsingDot(),
                    const SizedBox(width: 4),
                    Text(
                      l10n.orderTrackingLive,
                      style: const TextStyle(
                        color: AppColors.emeraldGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (var i = 0; i < _lifecycle.length; i++)
          _TimelineStep(
            status: _lifecycle[i],
            state: i < currentIndex
                ? _StepState.done
                : i == currentIndex
                    ? _StepState.current
                    : _StepState.upcoming,
            isLast: i == _lifecycle.length - 1,
          ),
      ],
    );
  }
}

enum _StepState { done, current, upcoming }

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.status, required this.state, required this.isLast});

  final OrderStatus status;
  final _StepState state;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDone = state == _StepState.done;
    final isCurrent = state == _StepState.current;
    final textColor = isDone || isCurrent
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withValues(alpha: 0.45);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? AppColors.emeraldGreen
                      : isCurrent
                          ? Colors.transparent
                          : theme.colorScheme.surfaceContainerHighest,
                  border: isCurrent ? Border.all(color: AppColors.emeraldGreen, width: 2) : null,
                ),
                child: isDone
                    ? const Icon(LucideIcons.checkCircle2, size: 14, color: Colors.white)
                    : isCurrent
                        ? const Padding(
                            padding: EdgeInsets.all(5),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.emeraldGreen,
                              ),
                            ),
                          )
                        : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: isDone ? AppColors.emeraldGreen : theme.colorScheme.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                orderStatusLabel(l10n, status.apiValue),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledBanner extends StatelessWidget {
  const _CancelledBanner({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.xCircle, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Text(
            l10n.orderStatusCancelled,
            style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1).animate(_controller),
      child: const DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.emeraldGreen),
        child: SizedBox(width: 6, height: 6),
      ),
    );
  }
}
