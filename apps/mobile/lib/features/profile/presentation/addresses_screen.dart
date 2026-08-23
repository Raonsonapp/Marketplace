import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../core/models/address.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/addresses_controller.dart';

/// Profile → My addresses (`GET/POST/PATCH/DELETE /addresses` —
/// docs/API_SPEC.md). Also the screen checkout links to for adding a new
/// delivery address.
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final addressesAsync = ref.watch(addressesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileAddresses)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressSheet(context, ref),
        child: const Icon(LucideIcons.plus),
      ),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return EmptyStateView(
              icon: LucideIcons.mapPin,
              title: l10n.checkoutAddressEmpty,
              actionLabel: l10n.checkoutAddressAdd,
              onAction: () => _showAddAddressSheet(context, ref),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: addresses.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Card(
                child: ListTile(
                  leading: const Icon(LucideIcons.mapPin),
                  title: Text(address.displayLine),
                  subtitle: address.isDefault ? Text(l10n.addressDefault) : null,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'default') {
                        ref.read(addressesControllerProvider.notifier).setDefault(address.id);
                      } else if (value == 'delete') {
                        ref.read(addressesControllerProvider.notifier).deleteAddress(address.id);
                      }
                    },
                    itemBuilder: (context) => [
                      if (!address.isDefault)
                        PopupMenuItem(value: 'default', child: Text(l10n.addressSetDefault)),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.addressDelete, style: const TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorStateView(
          error: error,
          onRetry: () => ref.read(addressesControllerProvider.notifier).refresh(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _showAddAddressSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => const _AddAddressSheet(),
    );
  }
}

class _AddAddressSheet extends ConsumerStatefulWidget {
  const _AddAddressSheet();

  @override
  ConsumerState<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends ConsumerState<_AddAddressSheet> {
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _houseController.dispose();
    _apartmentController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.checkoutAddressAdd, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: l10n.addressCity),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _streetController,
              decoration: InputDecoration(labelText: l10n.addressStreet),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _houseController,
                    decoration: InputDecoration(labelText: l10n.addressHouse),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _apartmentController,
                    decoration: InputDecoration(
                      labelText: '${l10n.addressApartment} ${l10n.commonOptional}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: '${l10n.addressComment} ${l10n.commonOptional}',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: l10n.commonSave,
              isLoading: _isSaving,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_cityController.text.trim().isEmpty || _streetController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    await ref.read(addressesControllerProvider.notifier).addAddress(Address(
          id: '',
          city: _cityController.text.trim(),
          street: _streetController.text.trim(),
          house: _houseController.text.trim().isEmpty ? null : _houseController.text.trim(),
          apartment:
              _apartmentController.text.trim().isEmpty ? null : _apartmentController.text.trim(),
          comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
        ));
    if (mounted) Navigator.of(context).pop();
  }
}
