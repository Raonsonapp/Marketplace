import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notification_models.dart';
import '../data/notifications_repository.dart';

/// Notification preference toggles
/// (`GET/PATCH /notifications/preferences` — docs/API_SPEC.md).
class NotificationPreferencesController extends AsyncNotifier<NotificationPreferences> {
  @override
  Future<NotificationPreferences> build() {
    return ref.watch(notificationsRepositoryProvider).getPreferences();
  }

  Future<void> setOrders(bool value) => _update((p) => p.copyWith(orders: value));
  Future<void> setPromotions(bool value) => _update((p) => p.copyWith(promotions: value));
  Future<void> setPersonalOffers(bool value) => _update((p) => p.copyWith(personalOffers: value));
  Future<void> setBonusUpdates(bool value) => _update((p) => p.copyWith(bonusUpdates: value));
  Future<void> setNewProducts(bool value) => _update((p) => p.copyWith(newProducts: value));

  Future<void> _update(
    NotificationPreferences Function(NotificationPreferences current) apply,
  ) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final optimistic = apply(current);
    state = AsyncData(optimistic);
    try {
      final saved =
          await ref.read(notificationsRepositoryProvider).updatePreferences(optimistic);
      state = AsyncData(saved);
    } catch (_) {
      // Revert on failure.
      state = AsyncData(current);
    }
  }
}

final notificationPreferencesControllerProvider =
    AsyncNotifierProvider<NotificationPreferencesController, NotificationPreferences>(
        NotificationPreferencesController.new);
