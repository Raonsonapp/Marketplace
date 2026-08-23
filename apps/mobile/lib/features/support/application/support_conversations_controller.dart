import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/support_models.dart';
import '../data/support_repository.dart';

/// Support ticket list (`GET/POST /support/conversations` —
/// docs/API_SPEC.md).
class SupportConversationsController extends AsyncNotifier<List<SupportConversation>> {
  @override
  Future<List<SupportConversation>> build() {
    return ref.watch(supportRepositoryProvider).getConversations();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<SupportConversation>>().copyWithPrevious(state);
    state =
        await AsyncValue.guard(() => ref.read(supportRepositoryProvider).getConversations());
  }

  /// Creates a new conversation and returns it so the caller can navigate
  /// straight into it, without waiting for a full list refresh first.
  Future<SupportConversation> startConversation({String? orderId}) async {
    final created =
        await ref.read(supportRepositoryProvider).createConversation(orderId: orderId);
    final current = state.valueOrNull ?? const [];
    state = AsyncData([created, ...current]);
    return created;
  }
}

final supportConversationsControllerProvider =
    AsyncNotifierProvider<SupportConversationsController, List<SupportConversation>>(
        SupportConversationsController.new);
