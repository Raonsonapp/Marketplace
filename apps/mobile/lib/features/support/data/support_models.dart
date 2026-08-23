import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_models.freezed.dart';
part 'support_models.g.dart';

/// One support ticket (`support_conversations` —
/// docs/DATABASE_SCHEMA.md), listed via `GET /support/conversations` and
/// created via `POST /support/conversations` (docs/API_SPEC.md).
@freezed
abstract class SupportConversation with _$SupportConversation {
  const factory SupportConversation({
    required String id,
    // 'open' | 'closed' (docs/DATABASE_SCHEMA.md CHECK constraint).
    required String status,
    String? orderId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SupportConversation;

  const SupportConversation._();

  factory SupportConversation.fromJson(Map<String, dynamic> json) =>
      _$SupportConversationFromJson(json);

  bool get isOpen => status == 'open';
}

/// One chat message (`support_messages` — docs/DATABASE_SCHEMA.md), from
/// `GET /support/conversations/:id/messages`, `POST` of the same, and the
/// `WS /ws/support/:conversationId` live feed (docs/API_SPEC.md).
@freezed
abstract class SupportMessage with _$SupportMessage {
  const factory SupportMessage({
    required String id,
    required String conversationId,
    required String senderId,
    // 'customer' | 'support_agent' | 'admin' (docs/DATABASE_SCHEMA.md
    // `support_messages.sender_role`, a free varchar — not a fixed enum).
    required String senderRole,
    String? text,
    String? imageUrl,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _SupportMessage;

  const SupportMessage._();

  factory SupportMessage.fromJson(Map<String, dynamic> json) => _$SupportMessageFromJson(json);

  bool get isFromCustomer => senderRole == 'customer';
}
