import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/email_entry_controller.dart';

/// Sign-in screen — the first step of the email OTP flow
/// (docs/API_SPEC.md `POST /auth/send-otp`). The address entered here both
/// receives the 6-digit code and identifies the account.
class EmailEntryScreen extends ConsumerStatefulWidget {
  const EmailEntryScreen({super.key});

  @override
  ConsumerState<EmailEntryScreen> createState() => _EmailEntryScreenState();
}

class _EmailEntryScreenState extends ConsumerState<EmailEntryScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(emailEntryControllerProvider);

    ref.listen(emailEntryControllerProvider, (previous, next) {
      if (next.otpSent && next.normalizedEmail != null) {
        ref.read(emailEntryControllerProvider.notifier).resetOtpSentFlag();
        context.push(
          RoutePaths.otp,
          extra: OtpRouteArgs(email: next.normalizedEmail!),
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
                l10n.authWelcomeSubtitleEmail,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.authEmailLabel, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                autofocus: true,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  LengthLimitingTextInputFormatter(255),
                ],
                onChanged: (value) =>
                    ref.read(emailEntryControllerProvider.notifier).updateInput(value),
                onSubmitted: (_) => ref.read(emailEntryControllerProvider.notifier).submit(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(LucideIcons.inbox),
                  hintText: l10n.authEmailHint,
                  errorText: state.showFormatError ? l10n.authEmailInvalid : null,
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
                onPressed: () => ref.read(emailEntryControllerProvider.notifier).submit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
