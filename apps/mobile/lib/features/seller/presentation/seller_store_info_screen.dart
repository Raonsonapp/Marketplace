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

/// Step 1 of the become-a-seller wizard: store GPS location, or — when
/// there's no physical store — at least one contact link. Neither is
/// individually required; the user just needs one of the two (enforced
/// both here and, again, by the backend).
class SellerStoreInfoScreen extends ConsumerStatefulWidget {
  const SellerStoreInfoScreen({super.key});

  @override
  ConsumerState<SellerStoreInfoScreen> createState() => _SellerStoreInfoScreenState();
}

class _SellerStoreInfoScreenState extends ConsumerState<SellerStoreInfoScreen> {
  final _website = TextEditingController();
  final _instagram = TextEditingController();
  final _telegram = TextEditingController();
  final _whatsapp = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _website.dispose();
    _instagram.dispose();
    _telegram.dispose();
    _whatsapp.dispose();
    super.dispose();
  }

  void _next() {
    final controller = ref.read(sellerOnboardingControllerProvider.notifier);
    controller.setSocialLinks(
      website: _website.text.trim().isEmpty ? null : _website.text.trim(),
      instagram: _instagram.text.trim().isEmpty ? null : _instagram.text.trim(),
      telegram: _telegram.text.trim().isEmpty ? null : _telegram.text.trim(),
      whatsapp: _whatsapp.text.trim().isEmpty ? null : _whatsapp.text.trim(),
    );
    if (!ref.read(sellerOnboardingControllerProvider).hasStoreInfo) {
      setState(() => _showError = true);
      return;
    }
    setState(() => _showError = false);
    context.push(RoutePaths.becomeSellerDocuments);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(sellerOnboardingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellerStoreInfoTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.sellerStoreInfoSubtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: state.isLocating
                    ? null
                    : () => ref.read(sellerOnboardingControllerProvider.notifier).useCurrentLocation(),
                icon: state.isLocating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(LucideIcons.mapPin),
                label: Text(
                  state.storeLat != null ? l10n.sellerLocationCaptured : l10n.sellerUseMyLocation,
                ),
              ),
              if (state.error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  ErrorStateView.messageFor(context, state.error!),
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.commonOptional, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _website,
                decoration: InputDecoration(labelText: l10n.sellerWebsiteLabel),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _instagram,
                decoration: InputDecoration(labelText: l10n.sellerInstagramLabel),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _telegram,
                decoration: InputDecoration(labelText: l10n.sellerTelegramLabel),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _whatsapp,
                decoration: InputDecoration(labelText: l10n.sellerWhatsappLabel),
                keyboardType: TextInputType.phone,
              ),
              if (_showError) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.sellerStoreInfoRequiredError,
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: l10n.commonContinue, onPressed: _next),
            ],
          ),
        ),
      ),
    );
  }
}
