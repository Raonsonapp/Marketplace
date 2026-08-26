import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../core/location/location_service.dart';
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
  bool _isLocating = false;
  double? _lat;
  double? _lng;

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
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: _isLocating ? null : _useMyLocation,
              icon: _isLocating
                  ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(_lat != null ? LucideIcons.checkCircle : LucideIcons.mapPin),
              label: Text(_lat != null ? l10n.sellerLocationCaptured : l10n.sellerUseMyLocation),
            ),
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

  Future<void> _useMyLocation() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLocating = true);
    try {
      final loc = await ref.read(locationServiceProvider).currentLocation(withAddress: true);
      if (!mounted) return;
      setState(() {
        _lat = loc.latitude;
        _lng = loc.longitude;
        if (loc.city != null) _cityController.text = loc.city!;
        if (loc.street != null) _streetController.text = loc.street!;
        if (loc.house != null && _houseController.text.trim().isEmpty) {
          _houseController.text = loc.house!;
        }
      });
    } on LocationException catch (e) {
      if (!mounted) return;
      final message = switch (e.reason) {
        LocationFailure.serviceDisabled => l10n.locationServiceDisabled,
        LocationFailure.permissionDenied => l10n.locationPermissionDenied,
        LocationFailure.permissionDeniedForever => l10n.locationPermissionDeniedForever,
        LocationFailure.lookupFailed => l10n.locationLookupFailed,
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
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
          lat: _lat,
          lng: _lng,
        ));
    if (mounted) Navigator.of(context).pop();
  }
}
