import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/app_exception.dart';
import '../models/seller_application.dart';

/// Calls `POST /seller-applications` and `GET /seller-applications/me`
/// (docs/API_SPEC.md) — the "become a seller" onboarding flow.
class SellerApplicationRepository {
  SellerApplicationRepository(this._client);

  final ApiClient _client;

  Future<SellerApplication> create(CreateSellerApplicationRequest request) async {
    final json = await _client.post('/seller-applications', data: request.toJson());
    return SellerApplication.fromJson(json);
  }

  /// Returns null when the caller has no application yet (server 404,
  /// mapped by [ApiClient] into an [ApiException] with code NOT_FOUND).
  Future<SellerApplication?> getMine() async {
    try {
      final json = await _client.get('/seller-applications/me');
      return SellerApplication.fromJson(json);
    } on ApiException catch (e) {
      if (e.code == 'NOT_FOUND') return null;
      rethrow;
    }
  }
}

final sellerApplicationRepositoryProvider = Provider<SellerApplicationRepository>((ref) {
  return SellerApplicationRepository(ref.watch(apiClientProvider));
});
