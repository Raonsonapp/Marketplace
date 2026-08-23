// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String?,
      data: json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': ?instance.body,
      'data': instance.data,
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
    };

_NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferences(
  orders: json['orders'] as bool? ?? true,
  promotions: json['promotions'] as bool? ?? true,
  personalOffers: json['personal_offers'] as bool? ?? true,
  bonusUpdates: json['bonus_updates'] as bool? ?? true,
  newProducts: json['new_products'] as bool? ?? true,
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  _NotificationPreferences instance,
) => <String, dynamic>{
  'orders': instance.orders,
  'promotions': instance.promotions,
  'personal_offers': instance.personalOffers,
  'bonus_updates': instance.bonusUpdates,
  'new_products': instance.newProducts,
};
