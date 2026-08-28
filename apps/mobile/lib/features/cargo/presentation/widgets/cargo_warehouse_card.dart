import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';

import '../../../../core/models/country.dart';
import '../../../../core/region/country_controller.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/cargo_models.dart';

/// One destination's forwarding offer: the China address to ship to, the
/// per-kilo price and the transit time. The address is the one thing the
/// shopper has to hand to a Chinese seller verbatim, so it is selectable
/// and has a one-tap copy.
class CargoWarehouseCard extends ConsumerWidget {
  const CargoWarehouseCard({super.key, required this.tariff});

  final CargoTariff tariff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final countries = ref.watch(countriesProvider).valueOrNull ?? const <Country>[];
    final destination =
        countries.where((c) => c.code == tariff.destination).firstOrNull;

    // A parcel to Russia is priced in rubles and one to Tajikistan in
    // somoni, so the label follows the *destination*, not the market the
    // shopper happens to be browsing in.
    final rate = CurrencyFormatter.format(
      tariff.ratePerKg,
      languageCode: languageCode,
      currencyLabel: destination?.currencyLabel(languageCode),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  destination == null
                      ? tariff.destination
                      : '${destination.flagEmoji}  ${destination.name(languageCode)}',
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                Text(l10n.cargoRatePerKg(rate), style: theme.textTheme.titleSmall),
              ],
            ),
            if (tariff.estimatedDaysMin != null && tariff.estimatedDaysMax != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                l10n.cargoTransitDays(tariff.estimatedDaysMin!, tariff.estimatedDaysMax!),
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (tariff.warehouseAddress.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.cargoWarehouseAddress, style: theme.textTheme.labelMedium),
              const SizedBox(height: AppSpacing.xxs),
              SelectableText(tariff.warehouseAddress, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
                  onPressed: () => _copyAddress(context, l10n.cargoAddressCopied),
                  icon: const Icon(LucideIcons.package, size: 16),
                  label: Text(l10n.cargoCopyAddress),
                ),
              ),
            ],
            if (tariff.contactPhone.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(LucideIcons.headphones, size: 16),
                  const SizedBox(width: AppSpacing.xxs),
                  SelectableText(tariff.contactPhone, style: theme.textTheme.bodyMedium),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _copyAddress(BuildContext context, String confirmation) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: tariff.warehouseAddress));
    messenger.showSnackBar(SnackBar(content: Text(confirmation)));
  }
}
