import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/env.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

/// Links to the public legal pages the API serves at its root (`/privacy`,
/// `/terms`, `/delete-account`).
///
/// They open in the device browser rather than an in-app webview: these are
/// the same URLs given to the Play Console listing, and a Play reviewer
/// checking that the in-app link and the listed link agree should land on
/// exactly the same page.
class LegalScreen extends ConsumerWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.legalTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _LegalTile(
            icon: LucideIcons.shieldCheck,
            label: l10n.legalPrivacyPolicy,
            path: '/privacy',
          ),
          _LegalTile(
            icon: LucideIcons.receipt,
            label: l10n.legalTerms,
            path: '/terms',
          ),
          _LegalTile(
            icon: LucideIcons.trash2,
            label: l10n.legalDeleteAccountPage,
            path: '/delete-account',
          ),
        ],
      ),
    );
  }
}

class _LegalTile extends StatelessWidget {
  const _LegalTile({required this.icon, required this.label, required this.path});

  final IconData icon;
  final String label;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(LucideIcons.chevronRight),
        onTap: () => _open(context),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse('${Env.legalBaseUrl}$path');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.legalOpenFailed)));
    }
  }
}
