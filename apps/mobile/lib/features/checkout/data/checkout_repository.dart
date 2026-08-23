import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/network/api_client.dart';
import 'checkout_models.dart';

/// Calls `POST /checkout/quote` and `POST /orders` (docs/API_SPEC.md).
/// `POST /orders` carries an `Idempotency-Key` header so retrying a failed
/// submission can never create a duplicate order (docs/API_SPEC.md,
/// section 38 "double order submission").
class CheckoutRepository {
  CheckoutRepository(this._client);

  final ApiClient _client;
  final Uuid _uuid = const Uuid();

  Future<CheckoutQuote> getQuote({
    String? addressId,
    required DeliveryMethod deliveryMethod,
    String? promoCode,
    String? bonusAmount,
  }) async {
    final json = await _client.post('/checkout/quote', data: {
      if (addressId != null) 'address_id': addressId,
      'delivery_method': deliveryMethod.apiValue,
      if (promoCode != null) 'promo_code': promoCode,
      if (bonusAmount != null) 'bonus_amount': bonusAmount,
    });
    return CheckoutQuote.fromJson(json);
  }

  /// Generates a fresh idempotency key for one checkout attempt. Callers
  /// must reuse the same key across retries of the *same* user action and
  /// only mint a new one for a genuinely new order attempt.
  String newIdempotencyKey() => _uuid.v4();

  Future<PlacedOrder> placeOrder({
    required String idempotencyKey,
    String? addressId,
    required DeliveryMethod deliveryMethod,
    DateTime? scheduledAt,
    required String paymentMethod,
    String? promoCode,
    String? bonusAmount,
  }) async {
    final json = await _client.post(
      '/orders',
      data: {
        if (addressId != null) 'address_id': addressId,
        'delivery_method': deliveryMethod.apiValue,
        if (scheduledAt != null) 'scheduled_at': scheduledAt.toIso8601String(),
        'payment_method': paymentMethod,
        if (promoCode != null) 'promo_code': promoCode,
        if (bonusAmount != null) 'bonus_amount': bonusAmount,
      },
      headers: {'Idempotency-Key': idempotencyKey},
    );
    return PlacedOrder.fromJson(json);
  }
}

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepository(ref.watch(apiClientProvider));
});
