import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/models/country.dart';
import '../../../../core/region/country_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/cargo_controller.dart';
import '../../data/cargo_models.dart';

/// One registered parcel: what it is, where it is in the pipeline, what it
/// weighed and what it costs.
class CargoShipmentCard extends ConsumerWidget {
  const CargoShipmentCard({super.key, required this.shipment});

  final CargoShipment shipment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final countries = ref.watch(countriesProvider).valueOrNull ?? const <Country>[];
    final destination = countries.where((c) => c.code == shipment.destination).firstOrNull;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(shipment.description, style: theme.textTheme.titleSmall),
                ),
                const SizedBox(width: AppSpacing.xs),
                _StatusChip(status: shipment.status),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              [
                if (destination != null) destination.name(languageCode),
                DateFormat.yMMMd(languageCode).format(shipment.createdAt),
              ].join(' · '),
              style: theme.textTheme.bodySmall,
            ),
            if (shipment.trackCode != null && shipment.trackCode!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(LucideIcons.truck, size: 16),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: SelectableText(
                      shipment.trackCode!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    shipment.isPriced
                        ? l10n.cargoWeightKg(shipment.weightKg.toStringAsFixed(2))
                        : l10n.cargoAwaitingWeighing,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                if (shipment.isPriced)
                  Text(
                    CurrencyFormatter.format(
                      shipment.cost,
                      languageCode: languageCode,
                      currencyLabel: destination?.currencyLabel(languageCode),
                    ),
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: AppColors.emeraldGreen),
                  ),
              ],
            ),
            if (shipment.note != null && shipment.note!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(shipment.note!, style: theme.textTheme.bodySmall),
            ],
            if (shipment.status.isCancelable) ...[
              const SizedBox(height: AppSpacing.xs),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => _confirmCancel(context, ref),
                  child: Text(
                    l10n.cargoCancelParcel,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cargoCancelParcel),
        content: Text(l10n.cargoCancelConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(cargoShipmentsControllerProvider.notifier).cancel(shipment.id);
    } catch (error) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(ErrorStateView.messageFor(context, error))),
      );
    }
  }
}

/// Where the parcel is, as a colour-coded chip: green once it has landed,
/// muted while it is still moving, red if it was withdrawn.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final CargoStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = switch (status) {
      CargoStatus.registered => l10n.cargoStatusRegistered,
      CargoStatus.received => l10n.cargoStatusReceived,
      CargoStatus.shipped => l10n.cargoStatusShipped,
      CargoStatus.arrived => l10n.cargoStatusArrived,
      CargoStatus.delivered => l10n.cargoStatusDelivered,
      CargoStatus.cancelled => l10n.cargoStatusCancelled,
    };
    final color = switch (status) {
      CargoStatus.delivered || CargoStatus.arrived => AppColors.emeraldGreen,
      CargoStatus.cancelled => AppColors.error,
      _ => Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
