import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/checkout_controller.dart';
import '../data/checkout_models.dart';
import 'widgets/checkout_quote_summary.dart';

/// The checkout flow: delivery method, address, delivery time, payment
/// method (cash on delivery only, for now), the server quote, and placing
/// the order (docs/API_SPEC.md `POST /checkout/quote`, `POST /orders`).
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(checkoutControllerProvider);

    if (state.placedOrder != null) {
      return _OrderConfirmation(placedOrder: state.placedOrder!);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(l10n.checkoutDeliveryMethod, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          _DeliveryMethodSelector(state: state),
          const SizedBox(height: AppSpacing.lg),
          if (state.deliveryMethod == DeliveryMethod.delivery) ...[
            Text(l10n.checkoutAddressTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            _AddressSection(state: state),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(l10n.checkoutTimeTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          _DeliveryTimeSelector(state: state),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.checkoutPaymentTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          _PaymentMethodSelector(),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.checkoutQuoteTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          state.quote.when(
            data: (quote) => CheckoutQuoteSummary(quote: quote),
            error: (error, stackTrace) => ErrorStateView(
              error: error,
              onRetry: () => ref.invalidate(checkoutControllerProvider),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          if (state.placeOrderError != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              ErrorStateView.messageFor(context, state.placeOrderError!),
              style: const TextStyle(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: l10n.checkoutPlaceOrder,
            isLoading: state.isPlacingOrder,
            onPressed: state.quote.hasValue
                ? () => ref.read(checkoutControllerProvider.notifier).placeOrder()
                : null,
          ),
        ],
      ),
    );
  }
}

class _DeliveryMethodSelector extends ConsumerWidget {
  const _DeliveryMethodSelector({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return SegmentedButton<DeliveryMethod>(
      segments: [
        ButtonSegment(
          value: DeliveryMethod.delivery,
          label: Text(l10n.checkoutDeliveryMethodDelivery),
          icon: const Icon(LucideIcons.bike),
        ),
        ButtonSegment(
          value: DeliveryMethod.pickup,
          label: Text(l10n.checkoutDeliveryMethodPickup),
          icon: const Icon(LucideIcons.store),
        ),
      ],
      selected: {state.deliveryMethod},
      onSelectionChanged: (selection) =>
          ref.read(checkoutControllerProvider.notifier).setDeliveryMethod(selection.first),
    );
  }
}

class _AddressSection extends ConsumerWidget {
  const _AddressSection({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return state.addresses.when(
      data: (addresses) {
        if (addresses.isEmpty) {
          return OutlinedButton.icon(
            onPressed: () => context.push(RoutePaths.addresses),
            icon: const Icon(LucideIcons.mapPin),
            label: Text(l10n.checkoutAddressAdd),
          );
        }
        return RadioGroup<String>(
          groupValue: state.selectedAddressId,
          onChanged: (value) {
            if (value != null) {
              ref.read(checkoutControllerProvider.notifier).selectAddress(value);
            }
          },
          child: Column(
            children: [
              ...addresses.map((address) => RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    value: address.id,
                    title: Text(address.displayLine),
                  )),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => context.push(RoutePaths.addresses),
                  icon: const Icon(LucideIcons.plus, size: 18),
                  label: Text(l10n.checkoutAddressAdd),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorStateView(error: error, onRetry: () {}),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _DeliveryTimeSelector extends ConsumerWidget {
  const _DeliveryTimeSelector({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return RadioGroup<bool>(
      groupValue: state.isAsap,
      onChanged: (value) async {
        if (value == true) {
          ref.read(checkoutControllerProvider.notifier).setAsap(true);
          return;
        }
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 7)),
        );
        if (date == null || !context.mounted) return;
        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        if (time == null) return;
        final scheduled = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        ref.read(checkoutControllerProvider.notifier).setScheduledAt(scheduled);
      },
      child: Column(
        children: [
          RadioListTile<bool>(
            contentPadding: EdgeInsets.zero,
            value: true,
            title: Text(l10n.checkoutTimeAsap),
          ),
          RadioListTile<bool>(
            contentPadding: EdgeInsets.zero,
            value: false,
            title: Text(
              state.scheduledAt != null
                  ? DateFormat('d MMM, HH:mm').format(state.scheduledAt!)
                  : l10n.checkoutTimeScheduled,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Only cash-on-delivery is implemented today (docs/ARCHITECTURE.md:
    // `payment.Provider` interface has only `cash_on_delivery`). The list
    // shape already supports adding more methods later.
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      child: RadioGroup<String>(
        groupValue: kCashOnDeliveryMethod,
        onChanged: (_) {},
        child: RadioListTile<String>(
          value: kCashOnDeliveryMethod,
          title: Text(l10n.checkoutPaymentCashOnDelivery),
          secondary: const Icon(LucideIcons.creditCard),
        ),
      ),
    );
  }
}

class _OrderConfirmation extends StatelessWidget {
  const _OrderConfirmation({required this.placedOrder});

  final PlacedOrder placedOrder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: const BoxDecoration(
                  color: AppColors.discountBadgeBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.checkCircle2, color: AppColors.emeraldGreen, size: 56),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.checkoutOrderSuccessTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.checkoutOrderSuccessMessage(placedOrder.orderNumber),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: l10n.checkoutViewOrder,
                onPressed: () => context.go(RoutePaths.orderDetailPath(placedOrder.id)),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.go(RoutePaths.home),
                child: Text(l10n.checkoutBackToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
