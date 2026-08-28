import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/country.dart';
import '../../../../core/region/country_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/cargo_controller.dart';
import '../../data/cargo_models.dart';

/// Registers a parcel against one of the destinations forwarding is offered
/// for. Only the description is required: the tracking code often isn't
/// known yet when the shopper places the Chinese order, and holding the
/// registration back until it is would leave the parcel unregistered when
/// it reaches the warehouse.
class CargoRegisterSheet extends ConsumerStatefulWidget {
  const CargoRegisterSheet({super.key, required this.tariffs});

  final List<CargoTariff> tariffs;

  @override
  ConsumerState<CargoRegisterSheet> createState() => _CargoRegisterSheetState();
}

class _CargoRegisterSheetState extends ConsumerState<CargoRegisterSheet> {
  final _descriptionController = TextEditingController();
  final _trackCodeController = TextEditingController();
  final _productLinkController = TextEditingController();
  late String _destination = _initialDestination();
  bool _isSaving = false;
  Object? _error;

  /// Default to the market the shopper is in when forwarding is offered
  /// there, otherwise the first destination that is offered.
  String _initialDestination() {
    final selected = ref.read(selectedCountryProvider);
    final offered = widget.tariffs.map((t) => t.destination);
    return offered.contains(selected) ? selected : widget.tariffs.first.destination;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _trackCodeController.dispose();
    _productLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final countries = ref.watch(countriesProvider).valueOrNull ?? const <Country>[];

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
            Text(l10n.cargoRegisterParcel, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            if (widget.tariffs.length > 1) ...[
              DropdownButtonFormField<String>(
                initialValue: _destination,
                decoration: InputDecoration(labelText: l10n.cargoDestination),
                items: [
                  for (final tariff in widget.tariffs)
                    DropdownMenuItem(
                      value: tariff.destination,
                      child: Text(_destinationLabel(countries, tariff.destination, languageCode)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _destination = value);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.cargoDescription,
                helperText: l10n.cargoDescriptionHint,
              ),
              maxLength: 500,
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _trackCodeController,
              decoration: InputDecoration(
                labelText: '${l10n.cargoTrackCode} ${l10n.commonOptional}',
              ),
              maxLength: 100,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _productLinkController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: '${l10n.cargoProductLink} ${l10n.commonOptional}',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                ErrorStateView.messageFor(context, _error!),
                style: const TextStyle(color: AppColors.error),
              ),
            ],
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

  String _destinationLabel(List<Country> countries, String code, String languageCode) {
    for (final country in countries) {
      if (country.code == code) {
        return '${country.flagEmoji}  ${country.name(languageCode)}';
      }
    }
    return code;
  }

  Future<void> _submit() async {
    final description = _descriptionController.text.trim();
    if (description.isEmpty) return;
    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      final trackCode = _trackCodeController.text.trim();
      final productLink = _productLinkController.text.trim();
      await ref.read(cargoShipmentsControllerProvider.notifier).register(
            destination: _destination,
            description: description,
            trackCode: trackCode.isEmpty ? null : trackCode,
            productLink: productLink.isEmpty ? null : productLink,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _error = error;
      });
    }
  }
}
