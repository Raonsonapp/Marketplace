import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_response.dart';
import '../../../core/network/api_client.dart';
import 'notification_models.dart';

/// Calls `/notifications*` (docs/API_SPEC.md). `POST /devices` (FCM token
/// registration) is intentionally not called here: this pass wires only
/// the REST-backed list/preferences UI. Real push delivery needs an actual
/// FCM token, which needs `firebase_messaging` wired up first — that
/// package isn't a dependency yet (only `firebase_core`/`firebase_auth`
/// are, for Phone Auth), so there is no real token to register.
class NotificationsRepository {
  NotificationsRepository(this._client);

  final ApiClient _client;

  Future<PaginatedResponse<AppNotification>> getNotifications({String? cursor}) async {
    final json = await _client.get('/notifications', queryParameters: {
      'cursor': ?cursor,
    });
    return PaginatedResponse.fromJson(json, AppNotification.fromJson);
  }

  Future<void> markRead(String id) => _client.patch('/notifications/$id/read').then((_) {});

  Future<NotificationPreferences> getPreferences() async {
    final json = await _client.get('/notifications/preferences');
    return NotificationPreferences.fromJson(json);
  }

  Future<NotificationPreferences> updatePreferences(NotificationPreferences prefs) async {
    final json = await _client.patch('/notifications/preferences', data: prefs.toJson());
    return NotificationPreferences.fromJson(json);
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(ref.watch(apiClientProvider));
});
