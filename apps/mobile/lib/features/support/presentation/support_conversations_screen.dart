import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/support_conversations_controller.dart';
import '../data/support_models.dart';

/// Support conversation list (`GET/POST /support/conversations` —
/// docs/API_SPEC.md). Reachable from Profile ("Support") while
/// authenticated (router redirect guard).
class SupportConversationsScreen extends ConsumerWidget {
  const SupportConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final conversationsAsync = ref.watch(supportConversationsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startConversation(context, ref),
        icon: const Icon(LucideIcons.messageCircle),
        label: Text(l10n.supportNewConversation),
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return EmptyStateView(
              icon: LucideIcons.headphones,
              title: l10n.supportEmptyTitle,
              message: l10n.supportEmptyMessage,
              actionLabel: l10n.supportNewConversation,
              onAction: () => _startConversation(context, ref),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(supportConversationsControllerProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xxl * 2,
              ),
              itemCount: conversations.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _ConversationTile(conversation: conversation);
              },
            ),
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.read(supportConversationsControllerProvider.notifier).refresh(),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ListRowSkeleton(count: 3),
        ),
      ),
    );
  }

  Future<void> _startConversation(BuildContext context, WidgetRef ref) async {
    final conversation =
        await ref.read(supportConversationsControllerProvider.notifier).startConversation();
    if (!context.mounted) return;
    context.push(RoutePaths.supportChatPath(conversation.id));
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});

  final SupportConversation conversation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      onTap: () => context.push(RoutePaths.supportChatPath(conversation.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.messageCircle, color: AppColors.emeraldGreen),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.isOpen ? l10n.supportStatusOpen : l10n.supportStatusClosed,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    DateFormat('d MMM yyyy, HH:mm').format(conversation.updatedAt),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              conversation.isOpen ? LucideIcons.circleDot : LucideIcons.checkCircle,
              color: conversation.isOpen ? AppColors.emeraldGreen : AppColors.priceOld,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
