import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_response.dart';
import '../../../core/network/api_client.dart';
import 'loyalty_models.dart';

/// Calls `/loyalty*` (docs/API_SPEC.md). Every method requires an
/// authenticated session — the router guard keeps anonymous users off the
/// TajBonus screen, but a call made without a session still maps to a real
/// 401 as [ApiException].
class LoyaltyRepository {
  LoyaltyRepository(this._client);

  final ApiClient _client;

  Future<LoyaltyAccount> getAccount() async {
    final json = await _client.get('/loyalty');
    return LoyaltyAccount.fromJson(json);
  }

  Future<PaginatedResponse<LoyaltyTransaction>> getTransactions({String? cursor}) async {
    final json = await _client.get('/loyalty/transactions', queryParameters: {
      'cursor': ?cursor,
    });
    return PaginatedResponse.fromJson(json, LoyaltyTransaction.fromJson);
  }
}

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) {
  return LoyaltyRepository(ref.watch(apiClientProvider));
});
