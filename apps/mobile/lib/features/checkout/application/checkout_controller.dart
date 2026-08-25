import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/address.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/session/session_controller.dart';
import '../../cart/application/cart_controller.dart';
import '../../profile/data/address_repository.dart';
import '../data/checkout_models.dart';
import '../data/checkout_repository.dart';

part 'checkout_controller.freezed.dart';

const String kCashOnDeliveryMethod = 'cash_on_delivery';

@freezed
abstract class CheckoutState with _$CheckoutState {
  const factory CheckoutState({
    @Default(AsyncValue.loading()) AsyncValue<List<Address>> addresses,
    String? selectedAddressId,
    @Default(DeliveryMethod.delivery) DeliveryMethod deliveryMethod,
    @Default(true) bool isAsap,
    DateTime? scheduledAt,
    @Default(kCashOnDeliveryMethod) String paymentMethod,
    @Default(AsyncValue<CheckoutQuote>.loading()) AsyncValue<CheckoutQuote> quote,
    @Default(false) bool isPlacingOrder,
    AppException? placeOrderError,
    PlacedOrder? placedOrder,
    String? idempotencyKey,
  }) = _CheckoutState;
}

/// Drives the checkout flow: address selection, ASAP/scheduled delivery
/// time, the server-computed quote (`POST /checkout/quote`), and placing
/// the order (`POST /orders` with an `Idempotency-Key` — docs/API_SPEC.md,
/// docs/SECURITY.md).
class CheckoutController extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    _loadAddresses();
    _refreshQuote();
    return const CheckoutState();
  }

  Future<void> _loadAddresses() async {
    try {
      final addresses = await ref.read(addressRepositoryProvider).getAddresses();
      final defaultAddress = addresses.where((a) => a.isDefault).firstOrNull ??
          (addresses.isNotEmpty ? addresses.first : null);
      state = state.copyWith(
        addresses: AsyncData(addresses),
        selectedAddressId: state.selectedAddressId ?? defaultAddress?.id,
      );
      _refreshQuote();
    } catch (e) {
      state = state.copyWith(addresses: AsyncError(e, StackTrace.current));
    }
  }

  void selectAddress(String addressId) {
    state = state.copyWith(selectedAddressId: addressId);
    _refreshQuote();
  }

  void setDeliveryMethod(DeliveryMethod method) {
    state = state.copyWith(deliveryMethod: method);
    _refreshQuote();
  }

  void setAsap(bool asap) {
    state = state.copyWith(isAsap: asap, scheduledAt: asap ? null : state.scheduledAt);
    _refreshQuote();
  }

  void setScheduledAt(DateTime dateTime) {
    state = state.copyWith(isAsap: false, scheduledAt: dateTime);
    _refreshQuote();
  }

  Future<void> _refreshQuote() async {
    if (state.deliveryMethod == DeliveryMethod.delivery && state.selectedAddressId == null) {
      return;
    }
    state = state.copyWith(quote: const AsyncValue.loading());
    try {
      final quote = await ref.read(checkoutRepositoryProvider).getQuote(
            addressId: state.deliveryMethod == DeliveryMethod.delivery
                ? state.selectedAddressId
                : null,
            deliveryMethod: state.deliveryMethod,
          );
      state = state.copyWith(quote: AsyncData(quote));
    } catch (e) {
      state = state.copyWith(quote: AsyncError(e, StackTrace.current));
    }
  }

  Future<void> placeOrder() async {
    if (state.isPlacingOrder) return;
    // Reuse one idempotency key across retries of this same order attempt;
    // only mint a new one after a successful order (a fresh attempt).
    final key = state.idempotencyKey ?? ref.read(checkoutRepositoryProvider).newIdempotencyKey();
    state = state.copyWith(isPlacingOrder: true, placeOrderError: null, idempotencyKey: key);

    try {
      final order = await ref.read(checkoutRepositoryProvider).placeOrder(
            idempotencyKey: key,
            addressId:
                state.deliveryMethod == DeliveryMethod.delivery ? state.selectedAddressId : null,
            deliveryMethod: state.deliveryMethod,
            scheduledAt: state.isAsap ? null : state.scheduledAt,
            paymentMethod: state.paymentMethod,
          );
      state = state.copyWith(isPlacingOrder: false, placedOrder: order, idempotencyKey: null);
      ref.invalidate(cartControllerProvider);
    } catch (e) {
      state = state.copyWith(isPlacingOrder: false, placeOrderError: ErrorMapper.map(e));
    }
  }
}

final checkoutControllerProvider =
    NotifierProvider<CheckoutController, CheckoutState>(CheckoutController.new);

/// Whether checkout is even reachable right now (requires a session — the
/// router guard already enforces this, this is a defensive UI-level check).
final canCheckoutProvider = Provider<bool>((ref) {
  // .select avoids rebuilding on every SessionState change (e.g. a profile
  // field update) when only the isAuthenticated flag is actually needed.
  return ref.watch(sessionControllerProvider.select((s) => s.valueOrNull?.isAuthenticated ?? false));
});
