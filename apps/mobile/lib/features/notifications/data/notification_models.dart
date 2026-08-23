import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

/// One in-app notification (`GET /notifications` — docs/API_SPEC.md),
/// backed by the `notifications` table (docs/DATABASE_SCHEMA.md). `data` is
/// an opaque, type-specific payload (e.g. an order id) the backend attaches
/// — kept as a raw map since its shape varies per `type`.
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String type,
    required String title,
    String? body,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}

/// Per-category push/notification opt-in flags
/// (`GET/PATCH /notifications/preferences` — docs/API_SPEC.md), matching
/// docs/DATABASE_SCHEMA.md's `notification_preferences` columns exactly.
@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    @Default(true) bool orders,
    @Default(true) bool promotions,
    @Default(true) bool personalOffers,
    @Default(true) bool bonusUpdates,
    @Default(true) bool newProducts,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}
