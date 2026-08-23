import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      if (next.otpSent && next.normalizedPhone != null) {
        ref.read(phoneEntryControllerProvider.notifier).resetOtpSentFlag();
        context.push('${RoutePaths.otp}?phone=${Uri.encodeComponent(next.normalizedPhone!)}');
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
                child: const Icon(Icons.storefront, color: Colors.white, size: 32),
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
                        PhoneValidator.countryCode,
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
