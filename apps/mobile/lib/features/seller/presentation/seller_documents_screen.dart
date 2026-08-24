import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/seller_onboarding_controller.dart';

/// Step 2 of the become-a-seller wizard: date of birth (age 18+ is
/// enforced server-side, but a client-side check on submit avoids a wasted
/// round trip) and the three KYC photos, each captured live via the device
/// camera — never picked from the gallery, so a stale/fake photo can't be
/// substituted for the real document.
class SellerDocumentsScreen extends ConsumerStatefulWidget {
  const SellerDocumentsScreen({super.key});

  @override
  ConsumerState<SellerDocumentsScreen> createState() => _SellerDocumentsScreenState();
}

class _SellerDocumentsScreenState extends ConsumerState<SellerDocumentsScreen> {
  bool _showError = false;

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) {
      ref.read(sellerOnboardingControllerProvider.notifier).setBirthDate(picked);
    }
  }

  void _next() {
    final state = ref.read(sellerOnboardingControllerProvider);
    if (!state.hasAllDocuments) {
      setState(() => _showError = true);
      return;
    }
    setState(() => _showError = false);
    context.push(RoutePaths.becomeSellerFace);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(sellerOnboardingControllerProvider);
    final controller = ref.read(sellerOnboardingControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellerDocumentsTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(LucideIcons.user),
                title: Text(l10n.sellerBirthDateLabel),
                subtitle: Text(
                  state.birthDate == null
                      ? l10n.sellerBirthDateNotSet
                      : '${state.birthDate!.year}-${state.birthDate!.month.toString().padLeft(2, '0')}-${state.birthDate!.day.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: _pickBirthDate,
              ),
              const Divider(),
              _DocumentTile(
                label: l10n.sellerPassportFrontLabel,
                isUploaded: state.passportFrontKey != null,
                isUploading: state.uploadingSlot == SellerDocumentSlot.passportFront,
                onCapture: () => controller.captureDocument(SellerDocumentSlot.passportFront),
              ),
              _DocumentTile(
                label: l10n.sellerPassportBackLabel,
                isUploaded: state.passportBackKey != null,
                isUploading: state.uploadingSlot == SellerDocumentSlot.passportBack,
                onCapture: () => controller.captureDocument(SellerDocumentSlot.passportBack),
              ),
              _DocumentTile(
                label: l10n.sellerSelfieWithPassportLabel,
                isUploaded: state.selfieWithPassportKey != null,
                isUploading: state.uploadingSlot == SellerDocumentSlot.selfieWithPassport,
                onCapture: () => controller.captureDocument(SellerDocumentSlot.selfieWithPassport),
              ),
              if (state.error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  ErrorStateView.messageFor(context, state.error!),
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              if (_showError) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.sellerDocumentsIncompleteError, style: const TextStyle(color: AppColors.error)),
              ],
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: l10n.commonContinue, onPressed: _next),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.label,
    required this.isUploaded,
    required this.isUploading,
    required this.onCapture,
  });

  final String label;
  final bool isUploaded;
  final bool isUploading;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            isUploaded ? LucideIcons.checkCircle : LucideIcons.camera,
            color: isUploaded ? AppColors.emeraldGreen : null,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          OutlinedButton(
            onPressed: isUploading ? null : onCapture,
            child: isUploading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isUploaded ? l10n.sellerRetakePhoto : l10n.sellerCapturePhoto),
          ),
        ],
      ),
    );
  }
}
