import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_response.dart';
import '../../../core/models/product.dart';
import '../../../core/network/api_client.dart';

/// Calls `/favorites*` (see docs/API_SPEC.md). Every method here requires an
/// authenticated session — the router guard keeps anonymous users from
/// reaching favorites-only screens, but callers still get a real 401
/// mapped to [ApiException] if called without a session.
class FavoritesRepository {
  FavoritesRepository(this._client);

  final ApiClient _client;

  Future<PaginatedResponse<Product>> getFavorites({String? cursor}) async {
    final json = await _client.get('/favorites', queryParameters: {
      'cursor': ?cursor,
    });
    return PaginatedResponse.fromJson(json, Product.fromJson);
  }

  Future<void> addFavorite(String productId) => _client.post('/favorites/$productId');

  Future<void> removeFavorite(String productId) => _client.delete('/favorites/$productId');
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(ref.watch(apiClientProvider));
});
