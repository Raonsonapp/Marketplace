import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_state.dart';
import '../data/notification_models.dart';
import '../data/notifications_repository.dart';

/// Paginated notification list (`GET /notifications`,
/// `PATCH /notifications/:id/read` — docs/API_SPEC.md).
class NotificationsController extends AsyncNotifier<PaginatedState<AppNotification>> {
  @override
  Future<PaginatedState<AppNotification>> build() async {
    final page = await ref.watch(notificationsRepositoryProvider).getNotifications();
    return PaginatedState(items: page.data, nextCursor: page.nextCursor);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(notificationsRepositoryProvider)
          .getNotifications(cursor: current.nextCursor);
      state = AsyncData(current.copyWith(
        items: [...current.items, ...page.data],
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
        isLoadingMore: false,
      ));
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading<PaginatedState<AppNotification>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final page = await ref.read(notificationsRepositoryProvider).getNotifications();
      return PaginatedState(items: page.data, nextCursor: page.nextCursor);
    });
  }

  /// Marks [id] read both on the server and optimistically in the local
  /// list, so the UI updates instantly without waiting for a refetch.
  Future<void> markRead(String id) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final target = current.items.where((n) => n.id == id).firstOrNull;
    if (target == null || target.isRead) return;

    state = AsyncData(current.copyWith(
      items: [
        for (final n in current.items)
          if (n.id == id) n.copyWith(isRead: true) else n,
      ],
    ));
    try {
      await ref.read(notificationsRepositoryProvider).markRead(id);
    } catch (_) {
      // Revert on failure.
      state = AsyncData(current);
    }
  }
}

final notificationsControllerProvider =
    AsyncNotifierProvider<NotificationsController, PaginatedState<AppNotification>>(
        NotificationsController.new);
