// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportConversation {

 String get id; String get status; String? get orderId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SupportConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportConversationCopyWith<SupportConversation> get copyWith => _$SupportConversationCopyWithImpl<SupportConversation>(this as SupportConversation, _$identity);

  /// Serializes this SupportConversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,orderId,createdAt,updatedAt);

@override
String toString() {
  return 'SupportConversation(id: $id, status: $status, orderId: $orderId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SupportConversationCopyWith<$Res>  {
  factory $SupportConversationCopyWith(SupportConversation value, $Res Function(SupportConversation) _then) = _$SupportConversationCopyWithImpl;
@useResult
$Res call({
 String id, String status, String? orderId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SupportConversationCopyWithImpl<$Res>
    implements $SupportConversationCopyWith<$Res> {
  _$SupportConversationCopyWithImpl(this._self, this._then);

  final SupportConversation _self;
  final $Res Function(SupportConversation) _then;

/// Create a copy of SupportConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? orderId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(SupportConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportConversation].
extension SupportConversationPatterns on SupportConversation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportConversation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportConversation value)  $default,){
final _that = this;
switch (_that) {
case _SupportConversation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportConversation value)?  $default,){
final _that = this;
switch (_that) {
case _SupportConversation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status,  String? orderId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportConversation() when $default != null:
return $default(_that.id,_that.status,_that.orderId,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status,  String? orderId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SupportConversation():
return $default(_that.id,_that.status,_that.orderId,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status,  String? orderId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SupportConversation() when $default != null:
return $default(_that.id,_that.status,_that.orderId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportConversation extends SupportConversation {
  const _SupportConversation({required this.id, required this.status, this.orderId, required this.createdAt, required this.updatedAt}): super._();
  factory _SupportConversation.fromJson(Map<String, dynamic> json) => _$SupportConversationFromJson(json);

@override final  String id;
@override final  String status;
@override final  String? orderId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SupportConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportConversationCopyWith<_SupportConversation> get copyWith => __$SupportConversationCopyWithImpl<_SupportConversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,orderId,createdAt,updatedAt);

@override
String toString() {
  return 'SupportConversation(id: $id, status: $status, orderId: $orderId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SupportConversationCopyWith<$Res> implements $SupportConversationCopyWith<$Res> {
  factory _$SupportConversationCopyWith(_SupportConversation value, $Res Function(_SupportConversation) _then) = __$SupportConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String status, String? orderId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SupportConversationCopyWithImpl<$Res>
    implements _$SupportConversationCopyWith<$Res> {
  __$SupportConversationCopyWithImpl(this._self, this._then);

  final _SupportConversation _self;
  final $Res Function(_SupportConversation) _then;

/// Create a copy of SupportConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? orderId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SupportConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SupportMessage {

 String get id; String get conversationId; String get senderId; String get senderRole; String? get text; String? get imageUrl; bool get isRead; DateTime get createdAt;
/// Create a copy of SupportMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportMessageCopyWith<SupportMessage> get copyWith => _$SupportMessageCopyWithImpl<SupportMessage>(this as SupportMessage, _$identity);

  /// Serializes this SupportMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,senderRole,text,imageUrl,isRead,createdAt);

@override
String toString() {
  return 'SupportMessage(id: $id, conversationId: $conversationId, senderId: $senderId, senderRole: $senderRole, text: $text, imageUrl: $imageUrl, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SupportMessageCopyWith<$Res>  {
  factory $SupportMessageCopyWith(SupportMessage value, $Res Function(SupportMessage) _then) = _$SupportMessageCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String senderId, String senderRole, String? text, String? imageUrl, bool isRead, DateTime createdAt
});




}
/// @nodoc
class _$SupportMessageCopyWithImpl<$Res>
    implements $SupportMessageCopyWith<$Res> {
  _$SupportMessageCopyWithImpl(this._self, this._then);

  final SupportMessage _self;
  final $Res Function(SupportMessage) _then;

/// Create a copy of SupportMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? senderRole = null,Object? text = freezed,Object? imageUrl = freezed,Object? isRead = null,Object? createdAt = null,}) {
  return _then(SupportMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportMessage].
extension SupportMessagePatterns on SupportMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportMessage value)  $default,){
final _that = this;
switch (_that) {
case _SupportMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SupportMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String senderRole,  String? text,  String? imageUrl,  bool isRead,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderRole,_that.text,_that.imageUrl,_that.isRead,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String senderRole,  String? text,  String? imageUrl,  bool isRead,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SupportMessage():
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderRole,_that.text,_that.imageUrl,_that.isRead,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String senderId,  String senderRole,  String? text,  String? imageUrl,  bool isRead,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SupportMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderRole,_that.text,_that.imageUrl,_that.isRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportMessage extends SupportMessage {
  const _SupportMessage({required this.id, required this.conversationId, required this.senderId, required this.senderRole, this.text, this.imageUrl, this.isRead = false, required this.createdAt}): super._();
  factory _SupportMessage.fromJson(Map<String, dynamic> json) => _$SupportMessageFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String senderId;
@override final  String senderRole;
@override final  String? text;
@override final  String? imageUrl;
@override@JsonKey() final  bool isRead;
@override final  DateTime createdAt;

/// Create a copy of SupportMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportMessageCopyWith<_SupportMessage> get copyWith => __$SupportMessageCopyWithImpl<_SupportMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,senderRole,text,imageUrl,isRead,createdAt);

@override
String toString() {
  return 'SupportMessage(id: $id, conversationId: $conversationId, senderId: $senderId, senderRole: $senderRole, text: $text, imageUrl: $imageUrl, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SupportMessageCopyWith<$Res> implements $SupportMessageCopyWith<$Res> {
  factory _$SupportMessageCopyWith(_SupportMessage value, $Res Function(_SupportMessage) _then) = __$SupportMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String senderId, String senderRole, String? text, String? imageUrl, bool isRead, DateTime createdAt
});




}
/// @nodoc
class __$SupportMessageCopyWithImpl<$Res>
    implements _$SupportMessageCopyWith<$Res> {
  __$SupportMessageCopyWithImpl(this._self, this._then);

  final _SupportMessage _self;
  final $Res Function(_SupportMessage) _then;

/// Create a copy of SupportMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? senderRole = null,Object? text = freezed,Object? imageUrl = freezed,Object? isRead = null,Object? createdAt = null,}) {
  return _then(_SupportMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
