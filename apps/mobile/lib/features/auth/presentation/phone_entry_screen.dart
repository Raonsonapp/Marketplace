import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/phone_validator.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/phone_entry_controller.dart';

/// Phone-entry screen — the first step of the OTP login flow (docs/API_SPEC.md
/// `POST /auth/send-otp`).
class PhoneEntryScreen extends ConsumerStatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  ConsumerState<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends ConsumerState<PhoneEntryScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(phoneEntryControllerProvider);

    ref.listen(phoneEntryControllerProvider, (previous, next) {
      if (next.autoVerifiedAndLoggedIn) {
        // Firebase auto-verified the code on-device (Android SMS
        // auto-retrieval) and login already completed — skip OTP entry.
        context.go(RoutePaths.home);
        return;
      }
      if (next.otpSent && next.normalizedPhone != null) {
        ref.read(phoneEntryControllerProvider.notifier).resetOtpSentFlag();
        context.push(
          RoutePaths.otp,
          extra: OtpRouteArgs(
            phone: next.normalizedPhone!,
            firebaseVerificationId: next.firebaseVerificationId,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: const Icon(LucideIcons.store, color: Colors.white, size: 32),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.authWelcomeTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.authWelcomeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.authPhoneLabel, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              // Region selector: YouShop serves Tajikistan and Russia
              // (docs/SECURITY.md), so the country-code prefix is a choice,
              // not a fixed label.
              SegmentedButton<PhoneRegion>(
                segments: [
                  for (final region in PhoneRegion.values)
                    ButtonSegment(
                      value: region,
                      label: Text('${region.flag} ${region.countryCode}'),
                    ),
                ],
                selected: {state.region},
                onSelectionChanged: (selection) =>
                    ref.read(phoneEntryControllerProvider.notifier).setRegion(selection.first),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                autofocus: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d+\s]')),
                  LengthLimitingTextInputFormatter(20),
                ],
                onChanged: (value) => ref.read(phoneEntryControllerProvider.notifier).updateInput(value),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        state.region.countryCode,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  hintText: l10n.authPhoneHint,
                  errorText: state.showFormatError ? l10n.authPhoneInvalid : null,
                ),
              ),
              if (state.error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  ErrorStateView.messageFor(context, state.error!),
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: l10n.authSendCode,
                isLoading: state.isSubmitting,
                onPressed: () => ref.read(phoneEntryControllerProvider.notifier).submit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
