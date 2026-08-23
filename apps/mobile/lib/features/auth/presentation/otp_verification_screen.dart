import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/phone_validator.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/otp_controller.dart';

/// OTP-entry screen for the [phone] number that just received a code
/// (docs/API_SPEC.md `POST /auth/verify-otp`).
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = otpControllerProvider(widget.phone);
    final state = ref.watch(provider);

    ref.listen(provider, (previous, next) {
      if (next.verified) {
        context.go(RoutePaths.home);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authOtpTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.authOtpSubtitle(PhoneValidator.formatForDisplay(widget.phone)),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                textAlign: TextAlign.center,
                maxLength: AppConstants.otpLength,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(letterSpacing: 8),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(counterText: ''),
                onChanged: (value) {
                  ref.read(provider.notifier).updateCode(value);
                  if (value.length == AppConstants.otpLength) {
                    ref.read(provider.notifier).verify();
                  }
                },
              ),
              if (state.error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  ErrorStateView.messageFor(context, state.error!),
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: l10n.authVerify,
                isLoading: state.isVerifying,
                onPressed: state.code.length == AppConstants.otpLength
                    ? () => ref.read(provider.notifier).verify()
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: state.cooldownSeconds > 0
                    ? Text(
                        l10n.authResendCodeIn(state.cooldownSeconds),
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextButton(
                        onPressed: state.isResending ? null : () => ref.read(provider.notifier).resend(),
                        child: Text(l10n.authResendCode),
                      ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.authChangeNumber),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
