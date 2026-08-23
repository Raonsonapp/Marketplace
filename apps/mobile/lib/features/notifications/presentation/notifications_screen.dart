import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/notifications_controller.dart';
import 'widgets/notification_tile.dart';

/// Notifications list (`GET /notifications`,
/// `PATCH /notifications/:id/read` — docs/API_SPEC.md). Reachable from
/// Profile while authenticated (router redirect guard). No real push
/// delivery yet (see report) — this is a pull-to-refresh REST list.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
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
      ref.read(notificationsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(notificationsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            tooltip: l10n.notificationsPreferencesTitle,
            onPressed: () => context.push(RoutePaths.notificationPreferences),
          ),
        ],
      ),
      body: state.when(
        data: (data) {
          if (data.items.isEmpty) {
            return EmptyStateView(
              icon: LucideIcons.bell,
              title: l10n.notificationsEmptyTitle,
              message: l10n.notificationsEmptyMessage,
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(notificationsControllerProvider.notifier).refresh(),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: data.items.length + (data.hasMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                if (index >= data.items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final notification = data.items[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () =>
                      ref.read(notificationsControllerProvider.notifier).markRead(notification.id),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.read(notificationsControllerProvider.notifier).refresh(),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ListRowSkeleton(count: 5),
        ),
      ),
    );
  }
}
