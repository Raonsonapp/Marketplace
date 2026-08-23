import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../l10n/app_localizations.dart';
import '../application/notification_preferences_controller.dart';

/// Notification preferences (`GET/PATCH /notifications/preferences` —
/// docs/API_SPEC.md), one toggle per `notification_preferences` column
/// (docs/DATABASE_SCHEMA.md).
class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefsAsync = ref.watch(notificationPreferencesControllerProvider);
    final notifier = ref.read(notificationPreferencesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsPreferencesTitle)),
      body: prefsAsync.when(
        data: (prefs) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            SwitchListTile(
              title: Text(l10n.notificationsPrefOrders),
              value: prefs.orders,
              onChanged: notifier.setOrders,
            ),
            SwitchListTile(
              title: Text(l10n.notificationsPrefPromotions),
              value: prefs.promotions,
              onChanged: notifier.setPromotions,
            ),
            SwitchListTile(
              title: Text(l10n.notificationsPrefPersonalOffers),
              value: prefs.personalOffers,
              onChanged: notifier.setPersonalOffers,
            ),
            SwitchListTile(
              title: Text(l10n.notificationsPrefBonusUpdates),
              value: prefs.bonusUpdates,
              onChanged: notifier.setBonusUpdates,
            ),
            SwitchListTile(
              title: Text(l10n.notificationsPrefNewProducts),
              value: prefs.newProducts,
              onChanged: notifier.setNewProducts,
            ),
          ],
        ),
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.invalidate(notificationPreferencesControllerProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
