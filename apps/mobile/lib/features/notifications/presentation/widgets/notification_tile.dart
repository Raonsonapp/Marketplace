import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/notification_models.dart';

/// Best-effort icon per `notifications.type` (docs/DATABASE_SCHEMA.md — a
/// free-form `varchar(30)`, not a fixed enum); falls back to a generic
/// bell for any type the client doesn't specifically recognize.
IconData notificationTypeIcon(String type) {
  return switch (type) {
    'order' || 'orders' => LucideIcons.receipt,
    'promotion' || 'promotions' => LucideIcons.badgePercent,
    'personal_offer' || 'personal_offers' => LucideIcons.gift,
    'bonus_update' || 'bonus_updates' => LucideIcons.coins,
    'new_product' || 'new_products' => LucideIcons.shoppingBag,
    _ => LucideIcons.bell,
  };
}

/// One row in the notifications list. Unread notifications get a filled
/// dot and a subtly tinted background.
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: notification.isRead
              ? theme.colorScheme.surfaceContainerHighest
              : AppColors.emeraldGreen.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(notificationTypeIcon(notification.type), color: AppColors.emeraldGreen),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w700,
                    ),
                  ),
                  if (notification.body != null && notification.body!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(notification.body!, style: theme.textTheme.bodySmall),
                  ],
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    DateFormat('d MMM yyyy, HH:mm').format(notification.createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.emeraldGreen,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
