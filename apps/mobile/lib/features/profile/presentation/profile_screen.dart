import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../l10n/app_localizations.dart';
import '../application/profile_controller.dart';

/// The Profile tab (`GET /profile` — docs/API_SPEC.md). Only reachable
/// while authenticated (router redirect guard).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionUser = ref.watch(sessionControllerProvider).valueOrNull?.user;
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: profileAsync.when(
        data: (profile) {
          final user = profile ?? sessionUser;
          if (user == null) {
            return EmptyStateView(
              icon: LucideIcons.user,
              title: l10n.profileGuestTitle,
              message: l10n.profileGuestMessage,
              actionLabel: l10n.authSignIn,
              onAction: () => context.push(RoutePaths.login),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.emeraldGreen.withValues(alpha: 0.15),
                    backgroundImage:
                        user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                            ? NetworkImage(user.avatarUrl!)
                            : null,
                    child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                        ? const Icon(LucideIcons.user, color: AppColors.emeraldGreen, size: 32)
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (user.fullName == null || user.fullName!.isEmpty)
                              ? user.phone
                              : user.fullName!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(user.phone, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.edit3),
                    onPressed: () => context.push(RoutePaths.profileEdit),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _MenuTile(
                icon: LucideIcons.receipt,
                label: l10n.profileMyOrders,
                onTap: () => context.go(RoutePaths.orders),
              ),
              _MenuTile(
                icon: LucideIcons.heart,
                label: l10n.profileFavorites,
                onTap: () => context.push(RoutePaths.favorites),
              ),
              _MenuTile(
                icon: LucideIcons.mapPin,
                label: l10n.profileAddresses,
                onTap: () => context.push(RoutePaths.addresses),
              ),
              _MenuTile(
                icon: LucideIcons.settings,
                label: l10n.profileSettings,
                onTap: () => context.push(RoutePaths.profileSettings),
              ),
            ],
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.invalidate(profileControllerProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(LucideIcons.chevronRight),
        onTap: onTap,
      ),
    );
  }
}
