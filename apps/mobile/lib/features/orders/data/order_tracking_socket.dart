import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/config/env.dart';
import '../../../core/storage/secure_token_storage.dart';

/// Connects to `WS /ws/orders/:orderId` (docs/API_SPEC.md) for live order
/// status pushes, delivering each decoded status update via [onStatus].
/// Callers should also poll as a fallback (see `OrderDetailScreen`) since a
/// WebSocket can silently drop on mobile networks.
class OrderTrackingSocket {
  OrderTrackingSocket(this._ref);

  final Ref _ref;
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  bool get isConnected => _channel != null;

  Future<void> connect({
    required String orderId,
    required void Function(Map<String, dynamic> payload) onStatus,
    required void Function() onDone,
    required void Function(Object error) onError,
  }) async {
    final accessToken = await _ref.read(secureTokenStorageProvider).readAccessToken();
    final wsBase = Env.apiBaseUrl.replaceFirst(RegExp('^http'), 'ws');
    final uri = Uri.parse('$wsBase/ws/orders/$orderId').replace(
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
            onStatus(decoded);
          } catch (_) {
            // Not JSON / not a status payload — ignore, the REST poll
            // fallback will still keep the screen correct.
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
