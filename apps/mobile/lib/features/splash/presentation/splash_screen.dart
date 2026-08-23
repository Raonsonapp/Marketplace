import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

/// Shown while [SessionController] resolves whether a session exists
/// (reading the refresh token from secure storage). The router redirects
/// away from here as soon as that resolves.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.darkBackgroundGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/branding/app_icon.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.appTitle,
                style: const TextStyle(
                  color: AppColors.textOnDarkPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.splashTagline,
                style: const TextStyle(color: AppColors.textOnDarkSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.emeraldGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
