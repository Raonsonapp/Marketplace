import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../network/app_exception.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shared error-state widget with a retry callback. Every repository call
/// surfaces an [AppException]; this widget turns it into a localized
/// message (server-provided for [ApiException], locally-localized for
/// [NetworkException]) plus a retry button (see docs/ARCHITECTURE.md).
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.error,
    required this.onRetry,
    this.title,
  });

  final Object error;
  final VoidCallback onRetry;
  final String? title;

  static String messageFor(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context)!;
    if (error is ApiException) return error.message;
    if (error is NetworkException) {
      switch (error.kind) {
        case NetworkErrorKind.timeout:
          return l10n.networkErrorTimeout;
        case NetworkErrorKind.noConnection:
          return l10n.networkErrorNoConnection;
        case NetworkErrorKind.cancelled:
          return l10n.networkErrorCancelled;
        case NetworkErrorKind.unknown:
          return l10n.networkErrorUnknown;
      }
    }
    return l10n.commonErrorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, size: 40, color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title ?? l10n.commonErrorTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              messageFor(context, error),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}
