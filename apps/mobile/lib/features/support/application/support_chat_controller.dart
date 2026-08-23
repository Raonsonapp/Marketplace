import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/support_models.dart';
import '../data/support_repository.dart';

/// One conversation's message list (`GET/POST
/// /support/conversations/:id/messages` — docs/API_SPEC.md). The
/// `WS /ws/support/:conversationId` live feed is owned by the screen
/// (`SupportChatScreen`, mirroring `OrderDetailScreen`'s socket lifecycle)
/// and reports incoming pushes here via [appendIncoming].
class SupportChatController extends FamilyAsyncNotifier<List<SupportMessage>, String> {
  late String _conversationId;

  @override
  Future<List<SupportMessage>> build(String arg) {
    _conversationId = arg;
    return ref.watch(supportRepositoryProvider).getMessages(_conversationId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<SupportMessage>>().copyWithPrevious(state);
    state = await AsyncValue.guard(
      () => ref.read(supportRepositoryProvider).getMessages(_conversationId),
    );
  }

  Future<void> send(String text) async {
    final sent = await ref
        .read(supportRepositoryProvider)
        .sendMessage(conversationId: _conversationId, text: text);
    _appendIfNew(sent);
  }

  /// Called by the screen when the WebSocket pushes a new message — merged
  /// in by id so a message that both this client's own `send` and the
  /// server's broadcast deliver isn't shown twice.
  void appendIncoming(SupportMessage message) => _appendIfNew(message);

  void _appendIfNew(SupportMessage message) {
    final current = state.valueOrNull ?? const [];
    if (current.any((m) => m.id == message.id)) return;
    state = AsyncData([...current, message]);
  }
}

final supportChatControllerProvider =
    AsyncNotifierProvider.family<SupportChatController, List<SupportMessage>, String>(
        SupportChatController.new);
