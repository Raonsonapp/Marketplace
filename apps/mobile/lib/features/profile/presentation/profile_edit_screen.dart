import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/session/session_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/profile_controller.dart';

/// Profile edit screen (`PATCH /profile` — docs/API_SPEC.md).
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(sessionControllerProvider).valueOrNull?.user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileControllerProvider);

    ref.listen(profileControllerProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileEditTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.profileFullName, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            TextField(controller: _nameController),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.profileEmail, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            TextField(controller: _emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: l10n.commonSave,
              isLoading: profileState.isLoading,
              onPressed: () => ref.read(profileControllerProvider.notifier).updateProfile(
                    fullName: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
