import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'promotion_models.dart';

/// Calls `GET /promotions` (docs/API_SPEC.md). A small, bounded, per-user
/// list (like `/addresses` or `/categories`) rather than an ever-growing
/// feed, so it's just `{"data": [...]}` (see PromotionHandler.List), not
/// the cursor-paginated `{data, next_cursor}` envelope.
///
/// `POST /promo-codes/validate` (docs/API_SPEC.md) is not called from this
/// repository: promo codes are entered and applied directly in the cart via
/// `POST /cart/promo-code`, which already validates server-side in one step
/// (`CartRepository.applyPromoCode`) — a separate pre-validation call would
/// just be a second round-trip to the same check.
class PromotionsRepository {
  PromotionsRepository(this._client);

  final ApiClient _client;

  Future<List<Promotion>> getPromotions() async {
    final json = await _client.get('/promotions');
    final list = (json['data'] as List<dynamic>?) ?? const [];
    return list.map((e) => Promotion.fromJson(e as Map<String, dynamic>)).toList();
  }
}

final promotionsRepositoryProvider = Provider<PromotionsRepository>((ref) {
  return PromotionsRepository(ref.watch(apiClientProvider));
});
