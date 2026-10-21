import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/app_user.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/email_entry_controller.dart';
import '../data/auth_repository.dart';

/// Google is the primary sign-in method. Email OTP remains as an optional
/// fallback; legacy phone/SMS auth is disabled server-side by default.
class EmailEntryScreen extends ConsumerStatefulWidget {
  const EmailEntryScreen({super.key});

  @override
  ConsumerState<EmailEntryScreen> createState() => _EmailEntryScreenState();
}

class _EmailEntryScreenState extends ConsumerState<EmailEntryScreen> {
  final _controller = TextEditingController();
  bool _isGoogleSigningIn = false;
  String? _googleError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _textForLocale(String en, String tj, String ru) {
    final language = Localizations.localeOf(context).languageCode;
    if (language == 'ru') return ru;
    if (language == 'tg' || language == 'tj') return tj;
    return en;
  }

  Future<void> _signInWithGoogle() async {
    if (_isGoogleSigningIn) return;
    setState(() {
      _isGoogleSigningIn = true;
      _googleError = null;
    });

    try {
      final serverClientId = const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
      final googleSignIn = GoogleSignIn(
        scopes: const ['email', 'profile'],
        serverClientId: serverClientId.isEmpty ? null : serverClientId,
      );
      final account = await googleSignIn.signIn();
      if (account == null) return; // User cancelled the account picker.

      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw StateError(
          'Google did not return an ID token. Configure GOOGLE_SERVER_CLIENT_ID '
          'with the Web OAuth client ID for this project.',
        );
      }

      final tokens = await ref.read(authRepositoryProvider).signInWithGoogle(
            idToken: idToken,
          );
      final user = tokens.user ??
          AppUser(
            id: '',
            phone: '',
            email: account.email,
            fullName: account.displayName,
            avatarUrl: account.photoUrl,
          );

      await ref.read(sessionControllerProvider.notifier).completeLogin(
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
            user: user,
          );

      if (mounted) context.go(RoutePaths.home);
    } catch (_) {
      if (mounted) {
        setState(() {
          _googleError = _textForLocale(
            'Google sign-in failed. Check your connection and Google OAuth setup.',
            'Воридшавӣ бо Google ноком шуд. Пайвастшавӣ ва танзимоти Google-ро санҷед.',
            'Не удалось войти через Google. Проверьте соединение и настройки Google OAuth.',
          );
        });
      }
    } finally {
      if (mounted) setState(() => _isGoogleSigningIn = false);
    }
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
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isGoogleSigningIn ? null : _signInWithGoogle,
                  icon: _isGoogleSigningIn
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.g_mobiledata, size: 28),
                  label: Text(
                    _textForLocale(
                      'Continue with Google',
                      'Бо Google идома додан',
                      'Продолжить с Google',
                    ),
                  ),
                ),
              ),
              if (_googleError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(_googleError!, style: const TextStyle(color: AppColors.error)),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(_textForLocale('or use email', 'ё почтаи электронӣ', 'или по email')),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.authEmailLabel, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                autofocus: false,
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
