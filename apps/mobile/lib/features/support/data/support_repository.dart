import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'support_models.dart';

/// Calls `/support/conversations*` (docs/API_SPEC.md). Conversation lists
/// and one conversation's message history are both bare arrays here (like
/// `/addresses`) — a single user has a small, bounded number of support
/// tickets and, within one ticket, this app loads the full history once
/// and then relies on the WebSocket for anything new rather than paging
/// through old messages.
class SupportRepository {
  SupportRepository(this._client);

  final ApiClient _client;

  Future<List<SupportConversation>> getConversations() async {
    final raw = await _client.getRaw('/support/conversations');
    final list = (raw as List<dynamic>?) ?? const [];
    return list.map((e) => SupportConversation.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SupportConversation> createConversation({String? orderId}) async {
    final json = await _client.post('/support/conversations', data: {
      'order_id': ?orderId,
    });
    return SupportConversation.fromJson(json);
  }

  Future<List<SupportMessage>> getMessages(String conversationId) async {
    // `ApiClient.get` normalizes a bare JSON array into `{"data": [...]}`
    // (see `ApiClient._asMap`), so this reads the same way whether the
    // backend returns a plain array or the generic `{data, next_cursor}`
    // envelope (docs/API_SPEC.md conventions) — the full history is what
    // this screen needs either way, no pagination for the first pass.
    final json = await _client.get('/support/conversations/$conversationId/messages');
    final list = (json['data'] as List<dynamic>?) ?? const [];
    return list.map((e) => SupportMessage.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SupportMessage> sendMessage({
    required String conversationId,
    required String text,
    String? imageUrl,
  }) async {
    final json = await _client.post('/support/conversations/$conversationId/messages', data: {
      'text': text,
      'image_url': ?imageUrl,
    });
    return SupportMessage.fromJson(json);
  }
}

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepository(ref.watch(apiClientProvider));
});
