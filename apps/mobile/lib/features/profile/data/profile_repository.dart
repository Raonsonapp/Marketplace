import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_user.dart';
import '../../../core/network/api_client.dart';

/// Calls `GET/PATCH /profile` (docs/API_SPEC.md).
class ProfileRepository {
  ProfileRepository(this._client);

  final ApiClient _client;

  Future<AppUser> getProfile() async {
    final json = await _client.get('/profile');
    return AppUser.fromJson(json);
  }

  Future<AppUser> updateProfile({
    String? fullName,
    String? email,
    String? language,
  }) async {
    final json = await _client.patch('/profile', data: {
      'full_name': ?fullName,
      'email': ?email,
      'language': ?language,
    });
    return AppUser.fromJson(json);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider));
});
