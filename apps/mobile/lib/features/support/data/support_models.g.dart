// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportConversation _$SupportConversationFromJson(Map<String, dynamic> json) =>
    _SupportConversation(
      id: json['id'] as String,
      status: json['status'] as String,
      orderId: json['order_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SupportConversationToJson(
  _SupportConversation instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'order_id': ?instance.orderId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_SupportMessage _$SupportMessageFromJson(Map<String, dynamic> json) =>
    _SupportMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      senderRole: json['sender_role'] as String,
      text: json['text'] as String?,
      imageUrl: json['image_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SupportMessageToJson(_SupportMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'sender_role': instance.senderRole,
      'text': ?instance.text,
      'image_url': ?instance.imageUrl,
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
    };
