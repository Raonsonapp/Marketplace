import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/config/env.dart';
import '../../../core/storage/secure_token_storage.dart';

/// Connects to `WS /ws/support/:conversationId` (docs/API_SPEC.md) for live
/// chat message pushes. Mirrors `OrderTrackingSocket`'s connect/reconnect/
/// fallback shape exactly — same query-param bearer token, same
/// try/onError/onDone handling — just for support messages instead of
/// order status. Callers should also poll `GET .../messages` as a
/// fallback since a WebSocket can silently drop on mobile networks.
class SupportChatSocket {
  SupportChatSocket(this._ref);

  // WidgetRef (not Ref): always constructed from a ConsumerState's `ref`
  // field (see SupportChatScreen), matching OrderTrackingSocket.
  final WidgetRef _ref;
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  bool get isConnected => _channel != null;

  Future<void> connect({
    required String conversationId,
    required void Function(Map<String, dynamic> payload) onMessage,
    required void Function() onDone,
    required void Function(Object error) onError,
  }) async {
    final accessToken = await _ref.read(secureTokenStorageProvider).readAccessToken();
    final uri = Uri.parse('${Env.wsBaseUrl}/ws/support/$conversationId').replace(
      queryParameters: {
        if (accessToken != null && accessToken.isNotEmpty) 'token': accessToken,
      },
    );

    try {
      final channel = WebSocketChannel.connect(uri);
      await channel.ready;
      _channel = channel;
      _subscription = channel.stream.listen(
        (event) {
          try {
            final decoded = jsonDecode(event as String) as Map<String, dynamic>;
            onMessage(decoded);
          } catch (_) {
            // Not JSON / not a message payload — ignore, the REST fetch
            // fallback keeps the screen correct.
          }
        },
        onError: (Object error) {
          _channel = null;
          onError(error);
        },
        onDone: () {
          _channel = null;
          onDone();
        },
        cancelOnError: true,
      );
    } catch (error) {
      _channel = null;
      onError(error);
    }
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
  }
}
