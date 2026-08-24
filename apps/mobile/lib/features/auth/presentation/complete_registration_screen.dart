import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/application/profile_controller.dart';

/// Second step of registration, shown once right after a brand-new
/// account's first successful OTP verification (see
/// otp_controller.dart's `isNewUser` handling): collects an email via
/// `PATCH /profile` before the user reaches the rest of the app.
class CompleteRegistrationScreen extends ConsumerStatefulWidget {
  const CompleteRegistrationScreen({super.key});

  @override
  ConsumerState<CompleteRegistrationScreen> createState() => _CompleteRegistrationScreenState();
}

class _CompleteRegistrationScreenState extends ConsumerState<CompleteRegistrationScreen> {
  final _controller = TextEditingController();
  bool _showFormatError = false;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _controller.text.trim();
    if (!_emailPattern.hasMatch(email)) {
      setState(() => _showFormatError = true);
      return;
    }
    setState(() => _showFormatError = false);
    ref.read(profileControllerProvider.notifier).updateProfile(email: email);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileControllerProvider);

    ref.listen(profileControllerProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && context.mounted) {
        context.go(RoutePaths.home);
      }
    });

    final error = profileState.hasError ? profileState.error : null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.authCompleteRegTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.authCompleteRegSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.authEmailHint,
                  errorText: _showFormatError ? l10n.authEmailInvalid : null,
                ),
              ),
              if (error is AppException) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  ErrorStateView.messageFor(context, error),
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: l10n.commonContinue,
                isLoading: profileState.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
