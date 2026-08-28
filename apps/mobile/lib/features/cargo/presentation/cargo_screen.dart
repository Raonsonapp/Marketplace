import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../application/cargo_controller.dart';
import '../data/cargo_models.dart';
import 'widgets/cargo_register_sheet.dart';
import 'widgets/cargo_shipment_card.dart';
import 'widgets/cargo_warehouse_card.dart';

/// Cargo (`/cargo*` — docs/API_SPEC.md): forwarding parcels bought on
/// Chinese marketplaces to Tajikistan or Russia. The shopper ships to
/// YouShop's China warehouse, registers the parcel here, and follows it
/// through weighing, dispatch and arrival.
class CargoScreen extends ConsumerWidget {
  const CargoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tariffsAsync = ref.watch(cargoTariffsProvider);
    final shipmentsAsync = ref.watch(cargoShipmentsControllerProvider);
    final tariffs = tariffsAsync.valueOrNull ?? const <CargoTariff>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cargoTitle)),
      floatingActionButton: tariffs.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openRegisterSheet(context, tariffs),
              icon: const Icon(LucideIcons.plus),
              label: Text(l10n.cargoRegisterParcel),
            ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(cargoTariffsProvider);
          await ref.read(cargoShipmentsControllerProvider.notifier).refresh();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            // Clear of the extended FAB so the last card is never covered.
            AppSpacing.xxl + AppSpacing.lg,
          ),
          children: [
            Text(l10n.cargoHowItWorks, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            const _HowItWorksSteps(),
            const SizedBox(height: AppSpacing.lg),
            tariffsAsync.when(
              data: (data) => data.isEmpty
                  ? _CargoUnavailableCard(message: l10n.cargoUnavailableMessage)
                  : Column(
                      children: [
                        for (final tariff in data) ...[
                          CargoWarehouseCard(tariff: tariff),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ],
                    ),
              error: (error, stackTrace) => ErrorStateView(
                error: error,
                onRetry: () => ref.invalidate(cargoTariffsProvider),
              ),
              loading: () => const ListRowSkeleton(count: 2),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.cargoMyParcels, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            shipmentsAsync.when(
              data: (shipments) {
                if (shipments.isEmpty) {
                  return EmptyStateView(
                    icon: LucideIcons.package,
                    title: l10n.cargoEmptyTitle,
                    message: l10n.cargoEmptyMessage,
                  );
                }
                return Column(
                  children: [
                    for (final shipment in shipments) ...[
                      CargoShipmentCard(shipment: shipment),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              },
              error: (error, stackTrace) => ErrorStateView(
                error: error,
                onRetry: () => ref.read(cargoShipmentsControllerProvider.notifier).refresh(),
              ),
              loading: () => const ListRowSkeleton(count: 3),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openRegisterSheet(BuildContext context, List<CargoTariff> tariffs) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CargoRegisterSheet(tariffs: tariffs),
    );
  }
}

/// The four things the shopper does, in order. Static copy rather than
/// server-driven: the steps are the same for every destination, and the
/// per-destination details (address, price) live in the warehouse card.
class _HowItWorksSteps extends StatelessWidget {
  const _HowItWorksSteps();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = [
      l10n.cargoStepOrder,
      l10n.cargoStepShipToWarehouse,
      l10n.cargoStepRegister,
      l10n.cargoStepReceive,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: AppColors.emeraldGreen,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(steps[i], style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Shown when no destination has been switched on yet — the service exists
/// in the app but the operator has not published a warehouse address or a
/// rate, so there is nothing a shopper could act on.
class _CargoUnavailableCard extends StatelessWidget {
  const _CargoUnavailableCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(LucideIcons.clock),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
