import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'home_models.dart';

/// Calls `GET /home` (see docs/API_SPEC.md). Works anonymously; when a
/// session is present the interceptor attaches the bearer token and the
/// backend personalizes sections like `recommended`/`personal_offers`.
class HomeRepository {
  HomeRepository(this._client);

  final ApiClient _client;

  /// [country] narrows the feed's "nearby stores" to the shopper's own
  /// market — a Moscow shopper has no use for a Dushanbe store.
  Future<HomeFeed> getHomeFeed({String? country}) async {
    final json = await _client.get('/home', queryParameters: {
      'country': ?country,
    });
    return HomeFeed.fromJson(json);
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(apiClientProvider));
});
