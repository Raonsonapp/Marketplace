import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/seller_onboarding_controller.dart';
import '../models/seller_application.dart';

/// Entry point for "become a seller": shows the intro + start button when
/// the caller has no application yet, or a status card when they do
/// (GET /seller-applications/me).
class BecomeSellerScreen extends ConsumerWidget {
  const BecomeSellerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final applicationAsync = ref.watch(sellerMyApplicationProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellerMenuTitle)),
      body: SafeArea(
        child: applicationAsync.when(
          data: (application) => application == null
              ? _IntroView(l10n: l10n)
              : _StatusView(l10n: l10n, application: application),
          error: (error, stackTrace) => ErrorStateView(
            error: error,
            onRetry: () => ref.invalidate(sellerMyApplicationProvider),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _IntroView extends StatelessWidget {
  const _IntroView({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.store, size: 48, color: AppColors.emeraldGreen),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.sellerMenuTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.sellerIntroBody, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l10n.sellerIntroStart,
            onPressed: () => context.push(RoutePaths.becomeSellerStoreInfo),
          ),
        ],
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({required this.l10n, required this.application});

  final AppLocalizations l10n;
  final SellerApplication application;

  @override
  Widget build(BuildContext context) {
    final (icon, color, title, body) = switch (application.status) {
      'approved' => (LucideIcons.checkCircle, AppColors.emeraldGreen, l10n.sellerStatusApproved, ''),
      'rejected' => (LucideIcons.xCircle, AppColors.error, l10n.sellerStatusRejected, application.rejectionReason ?? ''),
      _ => (LucideIcons.clock, AppColors.warning, l10n.sellerStatusPending, ''),
    };

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.sellerStatusTitle,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          if (body.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
