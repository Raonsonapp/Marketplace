import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tajikshop/core/icons/app_icons.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../l10n/app_localizations.dart';
import '../application/support_chat_controller.dart';
import '../data/support_chat_socket.dart';
import '../data/support_models.dart';

/// One support conversation's chat (`GET/POST
/// /support/conversations/:id/messages` — docs/API_SPEC.md): message
/// history plus a text input.
///
/// Tracking: tries `WS /ws/support/:conversationId` for live pushes while
/// the screen is open, mirroring `OrderDetailScreen`/`OrderTrackingSocket`
/// exactly — if it never connects (or drops), falls back to polling
/// `GET .../messages` every few seconds so the screen still stays correct.
class SupportChatScreen extends ConsumerStatefulWidget {
  const SupportChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportChatScreen> {
  late final SupportChatSocket _socket;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _pollTimer;
  bool _wsConnected = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _socket = SupportChatSocket(ref);
    _startTracking();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _socket.disconnect();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startTracking() {
    _socket.connect(
      conversationId: widget.conversationId,
      onMessage: (payload) {
        if (!mounted) return;
        setState(() => _wsConnected = true);
        try {
          final message = SupportMessage.fromJson(payload);
          ref
              .read(supportChatControllerProvider(widget.conversationId).notifier)
              .appendIncoming(message);
          _scrollToBottom();
        } catch (_) {
          // Not a message payload — a REST refresh keeps the screen
          // correct regardless.
          ref.read(supportChatControllerProvider(widget.conversationId).notifier).refresh();
        }
      },
      onDone: () {
        if (!mounted) return;
        setState(() => _wsConnected = false);
        _startPollingFallback();
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _wsConnected = false);
        _startPollingFallback();
      },
    );
    // Also arm the polling fallback immediately: if the WebSocket never
    // calls back at all (e.g. connect() hangs on a flaky network), the
    // screen must still refresh itself rather than go stale forever.
    _startPollingFallback();
  }

  void _startPollingFallback() {
    if (_pollTimer != null) return;
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_wsConnected) return; // WS is live — no need to also poll.
      ref.read(supportChatControllerProvider(widget.conversationId).notifier).refresh();
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = supportChatControllerProvider(widget.conversationId);
    final messagesAsync = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.supportChatTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              _wsConnected ? l10n.orderTrackingLive : '',
              style: const TextStyle(color: AppColors.emeraldGreen, fontSize: 12),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return EmptyStateView(
                    icon: LucideIcons.messageCircle,
                    title: l10n.supportChatEmptyTitle,
                    message: l10n.supportChatEmptyMessage,
                  );
                }
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: messages.length,
                  itemBuilder: (context, index) => _MessageBubble(message: messages[index]),
                );
              },
              error: (error, stackTrace) => ErrorStateView(
                error: error,
                onRetry: () => ref.read(provider.notifier).refresh(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(hintText: l10n.supportChatInputHint),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton.filled(
                    onPressed: _isSending ? null : _send,
                    icon: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(LucideIcons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;
    setState(() => _isSending = true);
    try {
      await ref.read(supportChatControllerProvider(widget.conversationId).notifier).send(text);
      if (!mounted) return;
      _textController.clear();
      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ErrorStateView.messageFor(context, error))));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final SupportMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMine = message.isFromCustomer;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMine ? AppColors.emeraldGreen : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.imageUrl != null && message.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.xs),
                child: Image.network(
                  message.imageUrl!,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(LucideIcons.imageOff, size: 20),
                ),
              ),
            if (message.text != null && message.text!.isNotEmpty)
              Text(
                message.text!,
                style: TextStyle(color: isMine ? Colors.white : null),
              ),
            const SizedBox(height: 2),
            Text(
              DateFormat('HH:mm').format(message.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: isMine ? Colors.white70 : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
