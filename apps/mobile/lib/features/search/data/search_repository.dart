import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/models/paginated_response.dart';
import '../../../core/models/product.dart';
import '../../../core/network/api_client.dart';
import 'search_models.dart';

/// Calls `GET /search` and `GET /search/suggestions` (docs/API_SPEC.md).
/// Both work anonymously, with auth optional for personalized suggestions.
class SearchRepository {
  SearchRepository(this._client);

  final ApiClient _client;

  Future<PaginatedResponse<Product>> search({
    required String query,
    String? cursor,
    int limit = AppConstants.defaultPageSize,
  }) async {
    final json = await _client.get('/search', queryParameters: {
      'q': query,
      'limit': limit,
      'cursor': ?cursor,
    });
    return PaginatedResponse.fromJson(json, Product.fromJson);
  }

  Future<SearchSuggestions> getSuggestions(String query) async {
    final json = await _client.get('/search/suggestions', queryParameters: {'q': query});
    return SearchSuggestions.fromJson(json);
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(apiClientProvider));
});
