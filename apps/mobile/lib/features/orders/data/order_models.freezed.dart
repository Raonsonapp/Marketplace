// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderItemLine {

 String get productId; String get nameSnapshot; String get unitPrice; int get quantity; String get totalPrice;
/// Create a copy of OrderItemLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemLineCopyWith<OrderItemLine> get copyWith => _$OrderItemLineCopyWithImpl<OrderItemLine>(this as OrderItemLine, _$identity);

  /// Serializes this OrderItemLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.nameSnapshot, nameSnapshot) || other.nameSnapshot == nameSnapshot)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,nameSnapshot,unitPrice,quantity,totalPrice);

@override
String toString() {
  return 'OrderItemLine(productId: $productId, nameSnapshot: $nameSnapshot, unitPrice: $unitPrice, quantity: $quantity, totalPrice: $totalPrice)';
}


}

/// @nodoc
abstract mixin class $OrderItemLineCopyWith<$Res>  {
  factory $OrderItemLineCopyWith(OrderItemLine value, $Res Function(OrderItemLine) _then) = _$OrderItemLineCopyWithImpl;
@useResult
$Res call({
 String productId, String nameSnapshot, String unitPrice, int quantity, String totalPrice
});




}
/// @nodoc
class _$OrderItemLineCopyWithImpl<$Res>
    implements $OrderItemLineCopyWith<$Res> {
  _$OrderItemLineCopyWithImpl(this._self, this._then);

  final OrderItemLine _self;
  final $Res Function(OrderItemLine) _then;

/// Create a copy of OrderItemLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? nameSnapshot = null,Object? unitPrice = null,Object? quantity = null,Object? totalPrice = null,}) {
  return _then(OrderItemLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,nameSnapshot: null == nameSnapshot ? _self.nameSnapshot : nameSnapshot // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItemLine].
extension OrderItemLinePatterns on OrderItemLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemLine value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemLine value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String nameSnapshot,  String unitPrice,  int quantity,  String totalPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemLine() when $default != null:
return $default(_that.productId,_that.nameSnapshot,_that.unitPrice,_that.quantity,_that.totalPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String nameSnapshot,  String unitPrice,  int quantity,  String totalPrice)  $default,) {final _that = this;
switch (_that) {
case _OrderItemLine():
return $default(_that.productId,_that.nameSnapshot,_that.unitPrice,_that.quantity,_that.totalPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String nameSnapshot,  String unitPrice,  int quantity,  String totalPrice)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemLine() when $default != null:
return $default(_that.productId,_that.nameSnapshot,_that.unitPrice,_that.quantity,_that.totalPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItemLine implements OrderItemLine {
  const _OrderItemLine({required this.productId, required this.nameSnapshot, required this.unitPrice, required this.quantity, required this.totalPrice});
  factory _OrderItemLine.fromJson(Map<String, dynamic> json) => _$OrderItemLineFromJson(json);

@override final  String productId;
@override final  String nameSnapshot;
@override final  String unitPrice;
@override final  int quantity;
@override final  String totalPrice;

/// Create a copy of OrderItemLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemLineCopyWith<_OrderItemLine> get copyWith => __$OrderItemLineCopyWithImpl<_OrderItemLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.nameSnapshot, nameSnapshot) || other.nameSnapshot == nameSnapshot)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,nameSnapshot,unitPrice,quantity,totalPrice);

@override
String toString() {
  return 'OrderItemLine(productId: $productId, nameSnapshot: $nameSnapshot, unitPrice: $unitPrice, quantity: $quantity, totalPrice: $totalPrice)';
}


}

/// @nodoc
abstract mixin class _$OrderItemLineCopyWith<$Res> implements $OrderItemLineCopyWith<$Res> {
  factory _$OrderItemLineCopyWith(_OrderItemLine value, $Res Function(_OrderItemLine) _then) = __$OrderItemLineCopyWithImpl;
@override @useResult
$Res call({
 String productId, String nameSnapshot, String unitPrice, int quantity, String totalPrice
});




}
/// @nodoc
class __$OrderItemLineCopyWithImpl<$Res>
    implements _$OrderItemLineCopyWith<$Res> {
  __$OrderItemLineCopyWithImpl(this._self, this._then);

  final _OrderItemLine _self;
  final $Res Function(_OrderItemLine) _then;

/// Create a copy of OrderItemLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? nameSnapshot = null,Object? unitPrice = null,Object? quantity = null,Object? totalPrice = null,}) {
  return _then(_OrderItemLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,nameSnapshot: null == nameSnapshot ? _self.nameSnapshot : nameSnapshot // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OrderStatusEvent {

 String get status; String? get note; DateTime get createdAt;
/// Create a copy of OrderStatusEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderStatusEventCopyWith<OrderStatusEvent> get copyWith => _$OrderStatusEventCopyWithImpl<OrderStatusEvent>(this as OrderStatusEvent, _$identity);

  /// Serializes this OrderStatusEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderStatusEvent&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,note,createdAt);

@override
String toString() {
  return 'OrderStatusEvent(status: $status, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $OrderStatusEventCopyWith<$Res>  {
  factory $OrderStatusEventCopyWith(OrderStatusEvent value, $Res Function(OrderStatusEvent) _then) = _$OrderStatusEventCopyWithImpl;
@useResult
$Res call({
 String status, String? note, DateTime createdAt
});




}
/// @nodoc
class _$OrderStatusEventCopyWithImpl<$Res>
    implements $OrderStatusEventCopyWith<$Res> {
  _$OrderStatusEventCopyWithImpl(this._self, this._then);

  final OrderStatusEvent _self;
  final $Res Function(OrderStatusEvent) _then;

/// Create a copy of OrderStatusEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(OrderStatusEvent(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderStatusEvent].
extension OrderStatusEventPatterns on OrderStatusEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderStatusEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderStatusEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderStatusEvent value)  $default,){
final _that = this;
switch (_that) {
case _OrderStatusEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderStatusEvent value)?  $default,){
final _that = this;
switch (_that) {
case _OrderStatusEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? note,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderStatusEvent() when $default != null:
return $default(_that.status,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? note,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _OrderStatusEvent():
return $default(_that.status,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? note,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderStatusEvent() when $default != null:
return $default(_that.status,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderStatusEvent implements OrderStatusEvent {
  const _OrderStatusEvent({required this.status, this.note, required this.createdAt});
  factory _OrderStatusEvent.fromJson(Map<String, dynamic> json) => _$OrderStatusEventFromJson(json);

@override final  String status;
@override final  String? note;
@override final  DateTime createdAt;

/// Create a copy of OrderStatusEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderStatusEventCopyWith<_OrderStatusEvent> get copyWith => __$OrderStatusEventCopyWithImpl<_OrderStatusEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderStatusEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderStatusEvent&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,note,createdAt);

@override
String toString() {
  return 'OrderStatusEvent(status: $status, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OrderStatusEventCopyWith<$Res> implements $OrderStatusEventCopyWith<$Res> {
  factory _$OrderStatusEventCopyWith(_OrderStatusEvent value, $Res Function(_OrderStatusEvent) _then) = __$OrderStatusEventCopyWithImpl;
@override @useResult
$Res call({
 String status, String? note, DateTime createdAt
});




}
/// @nodoc
class __$OrderStatusEventCopyWithImpl<$Res>
    implements _$OrderStatusEventCopyWith<$Res> {
  __$OrderStatusEventCopyWithImpl(this._self, this._then);

  final _OrderStatusEvent _self;
  final $Res Function(_OrderStatusEvent) _then;

/// Create a copy of OrderStatusEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_OrderStatusEvent(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$OrderSummary {

 String get id; String get orderNumber; String get status; String get total; DateTime get createdAt; int get itemCount;
/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSummaryCopyWith<OrderSummary> get copyWith => _$OrderSummaryCopyWithImpl<OrderSummary>(this as OrderSummary, _$identity);

  /// Serializes this OrderSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.total, total) || other.total == total)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status,total,createdAt,itemCount);

@override
String toString() {
  return 'OrderSummary(id: $id, orderNumber: $orderNumber, status: $status, total: $total, createdAt: $createdAt, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class $OrderSummaryCopyWith<$Res>  {
  factory $OrderSummaryCopyWith(OrderSummary value, $Res Function(OrderSummary) _then) = _$OrderSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String orderNumber, String status, String total, DateTime createdAt, int itemCount
});




}
/// @nodoc
class _$OrderSummaryCopyWithImpl<$Res>
    implements $OrderSummaryCopyWith<$Res> {
  _$OrderSummaryCopyWithImpl(this._self, this._then);

  final OrderSummary _self;
  final $Res Function(OrderSummary) _then;

/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? status = null,Object? total = null,Object? createdAt = null,Object? itemCount = null,}) {
  return _then(OrderSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderSummary].
extension OrderSummaryPatterns on OrderSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderSummary value)  $default,){
final _that = this;
switch (_that) {
case _OrderSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderSummary value)?  $default,){
final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String status,  String total,  DateTime createdAt,  int itemCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that.id,_that.orderNumber,_that.status,_that.total,_that.createdAt,_that.itemCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String status,  String total,  DateTime createdAt,  int itemCount)  $default,) {final _that = this;
switch (_that) {
case _OrderSummary():
return $default(_that.id,_that.orderNumber,_that.status,_that.total,_that.createdAt,_that.itemCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderNumber,  String status,  String total,  DateTime createdAt,  int itemCount)?  $default,) {final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that.id,_that.orderNumber,_that.status,_that.total,_that.createdAt,_that.itemCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderSummary implements OrderSummary {
  const _OrderSummary({required this.id, required this.orderNumber, required this.status, required this.total, required this.createdAt, this.itemCount = 0});
  factory _OrderSummary.fromJson(Map<String, dynamic> json) => _$OrderSummaryFromJson(json);

@override final  String id;
@override final  String orderNumber;
@override final  String status;
@override final  String total;
@override final  DateTime createdAt;
@override@JsonKey() final  int itemCount;

/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSummaryCopyWith<_OrderSummary> get copyWith => __$OrderSummaryCopyWithImpl<_OrderSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.total, total) || other.total == total)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status,total,createdAt,itemCount);

@override
String toString() {
  return 'OrderSummary(id: $id, orderNumber: $orderNumber, status: $status, total: $total, createdAt: $createdAt, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class _$OrderSummaryCopyWith<$Res> implements $OrderSummaryCopyWith<$Res> {
  factory _$OrderSummaryCopyWith(_OrderSummary value, $Res Function(_OrderSummary) _then) = __$OrderSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderNumber, String status, String total, DateTime createdAt, int itemCount
});




}
/// @nodoc
class __$OrderSummaryCopyWithImpl<$Res>
    implements _$OrderSummaryCopyWith<$Res> {
  __$OrderSummaryCopyWithImpl(this._self, this._then);

  final _OrderSummary _self;
  final $Res Function(_OrderSummary) _then;

/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? status = null,Object? total = null,Object? createdAt = null,Object? itemCount = null,}) {
  return _then(_OrderSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OrderDetail {

 String get id; String get orderNumber; String get status; String get deliveryMethod; String get paymentMethod; String get subtotal; String get discountAmount; String get deliveryFee; String get bonusUsed; String get total; DateTime get createdAt; DateTime? get scheduledAt; String? get deliveryNote; String? get cancelledReason; List<OrderItemLine> get items; List<OrderStatusEvent> get statusHistory;
/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailCopyWith<OrderDetail> get copyWith => _$OrderDetailCopyWithImpl<OrderDetail>(this as OrderDetail, _$identity);

  /// Serializes this OrderDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryMethod, deliveryMethod) || other.deliveryMethod == deliveryMethod)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.bonusUsed, bonusUsed) || other.bonusUsed == bonusUsed)&&(identical(other.total, total) || other.total == total)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.deliveryNote, deliveryNote) || other.deliveryNote == deliveryNote)&&(identical(other.cancelledReason, cancelledReason) || other.cancelledReason == cancelledReason)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.statusHistory, statusHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status,deliveryMethod,paymentMethod,subtotal,discountAmount,deliveryFee,bonusUsed,total,createdAt,scheduledAt,deliveryNote,cancelledReason,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(statusHistory));

@override
String toString() {
  return 'OrderDetail(id: $id, orderNumber: $orderNumber, status: $status, deliveryMethod: $deliveryMethod, paymentMethod: $paymentMethod, subtotal: $subtotal, discountAmount: $discountAmount, deliveryFee: $deliveryFee, bonusUsed: $bonusUsed, total: $total, createdAt: $createdAt, scheduledAt: $scheduledAt, deliveryNote: $deliveryNote, cancelledReason: $cancelledReason, items: $items, statusHistory: $statusHistory)';
}


}

/// @nodoc
abstract mixin class $OrderDetailCopyWith<$Res>  {
  factory $OrderDetailCopyWith(OrderDetail value, $Res Function(OrderDetail) _then) = _$OrderDetailCopyWithImpl;
@useResult
$Res call({
 String id, String orderNumber, String status, String deliveryMethod, String paymentMethod, String subtotal, String discountAmount, String deliveryFee, String bonusUsed, String total, DateTime createdAt, DateTime? scheduledAt, String? deliveryNote, String? cancelledReason, List<OrderItemLine> items, List<OrderStatusEvent> statusHistory
});




}
/// @nodoc
class _$OrderDetailCopyWithImpl<$Res>
    implements $OrderDetailCopyWith<$Res> {
  _$OrderDetailCopyWithImpl(this._self, this._then);

  final OrderDetail _self;
  final $Res Function(OrderDetail) _then;

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? status = null,Object? deliveryMethod = null,Object? paymentMethod = null,Object? subtotal = null,Object? discountAmount = null,Object? deliveryFee = null,Object? bonusUsed = null,Object? total = null,Object? createdAt = null,Object? scheduledAt = freezed,Object? deliveryNote = freezed,Object? cancelledReason = freezed,Object? items = null,Object? statusHistory = null,}) {
  return _then(OrderDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deliveryMethod: null == deliveryMethod ? _self.deliveryMethod : deliveryMethod // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as String,bonusUsed: null == bonusUsed ? _self.bonusUsed : bonusUsed // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryNote: freezed == deliveryNote ? _self.deliveryNote : deliveryNote // ignore: cast_nullable_to_non_nullable
as String?,cancelledReason: freezed == cancelledReason ? _self.cancelledReason : cancelledReason // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemLine>,statusHistory: null == statusHistory ? _self.statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<OrderStatusEvent>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderDetail].
extension OrderDetailPatterns on OrderDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDetail value)  $default,){
final _that = this;
switch (_that) {
case _OrderDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDetail value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String status,  String deliveryMethod,  String paymentMethod,  String subtotal,  String discountAmount,  String deliveryFee,  String bonusUsed,  String total,  DateTime createdAt,  DateTime? scheduledAt,  String? deliveryNote,  String? cancelledReason,  List<OrderItemLine> items,  List<OrderStatusEvent> statusHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
return $default(_that.id,_that.orderNumber,_that.status,_that.deliveryMethod,_that.paymentMethod,_that.subtotal,_that.discountAmount,_that.deliveryFee,_that.bonusUsed,_that.total,_that.createdAt,_that.scheduledAt,_that.deliveryNote,_that.cancelledReason,_that.items,_that.statusHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String status,  String deliveryMethod,  String paymentMethod,  String subtotal,  String discountAmount,  String deliveryFee,  String bonusUsed,  String total,  DateTime createdAt,  DateTime? scheduledAt,  String? deliveryNote,  String? cancelledReason,  List<OrderItemLine> items,  List<OrderStatusEvent> statusHistory)  $default,) {final _that = this;
switch (_that) {
case _OrderDetail():
return $default(_that.id,_that.orderNumber,_that.status,_that.deliveryMethod,_that.paymentMethod,_that.subtotal,_that.discountAmount,_that.deliveryFee,_that.bonusUsed,_that.total,_that.createdAt,_that.scheduledAt,_that.deliveryNote,_that.cancelledReason,_that.items,_that.statusHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderNumber,  String status,  String deliveryMethod,  String paymentMethod,  String subtotal,  String discountAmount,  String deliveryFee,  String bonusUsed,  String total,  DateTime createdAt,  DateTime? scheduledAt,  String? deliveryNote,  String? cancelledReason,  List<OrderItemLine> items,  List<OrderStatusEvent> statusHistory)?  $default,) {final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
return $default(_that.id,_that.orderNumber,_that.status,_that.deliveryMethod,_that.paymentMethod,_that.subtotal,_that.discountAmount,_that.deliveryFee,_that.bonusUsed,_that.total,_that.createdAt,_that.scheduledAt,_that.deliveryNote,_that.cancelledReason,_that.items,_that.statusHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderDetail implements OrderDetail {
  const _OrderDetail({required this.id, required this.orderNumber, required this.status, required this.deliveryMethod, required this.paymentMethod, required this.subtotal, this.discountAmount = '0.00', this.deliveryFee = '0.00', this.bonusUsed = '0.00', required this.total, required this.createdAt, this.scheduledAt, this.deliveryNote, this.cancelledReason,  List<OrderItemLine> items = const <OrderItemLine>[],  List<OrderStatusEvent> statusHistory = const <OrderStatusEvent>[]}): _items = items,_statusHistory = statusHistory;
  factory _OrderDetail.fromJson(Map<String, dynamic> json) => _$OrderDetailFromJson(json);

@override final  String id;
@override final  String orderNumber;
@override final  String status;
@override final  String deliveryMethod;
@override final  String paymentMethod;
@override final  String subtotal;
@override@JsonKey() final  String discountAmount;
@override@JsonKey() final  String deliveryFee;
@override@JsonKey() final  String bonusUsed;
@override final  String total;
@override final  DateTime createdAt;
@override final  DateTime? scheduledAt;
@override final  String? deliveryNote;
@override final  String? cancelledReason;
 final  List<OrderItemLine> _items;
@override@JsonKey() List<OrderItemLine> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<OrderStatusEvent> _statusHistory;
@override@JsonKey() List<OrderStatusEvent> get statusHistory {
  if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusHistory);
}


/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDetailCopyWith<_OrderDetail> get copyWith => __$OrderDetailCopyWithImpl<_OrderDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryMethod, deliveryMethod) || other.deliveryMethod == deliveryMethod)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.bonusUsed, bonusUsed) || other.bonusUsed == bonusUsed)&&(identical(other.total, total) || other.total == total)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.deliveryNote, deliveryNote) || other.deliveryNote == deliveryNote)&&(identical(other.cancelledReason, cancelledReason) || other.cancelledReason == cancelledReason)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._statusHistory, _statusHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status,deliveryMethod,paymentMethod,subtotal,discountAmount,deliveryFee,bonusUsed,total,createdAt,scheduledAt,deliveryNote,cancelledReason,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_statusHistory));

@override
String toString() {
  return 'OrderDetail(id: $id, orderNumber: $orderNumber, status: $status, deliveryMethod: $deliveryMethod, paymentMethod: $paymentMethod, subtotal: $subtotal, discountAmount: $discountAmount, deliveryFee: $deliveryFee, bonusUsed: $bonusUsed, total: $total, createdAt: $createdAt, scheduledAt: $scheduledAt, deliveryNote: $deliveryNote, cancelledReason: $cancelledReason, items: $items, statusHistory: $statusHistory)';
}


}

/// @nodoc
abstract mixin class _$OrderDetailCopyWith<$Res> implements $OrderDetailCopyWith<$Res> {
  factory _$OrderDetailCopyWith(_OrderDetail value, $Res Function(_OrderDetail) _then) = __$OrderDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderNumber, String status, String deliveryMethod, String paymentMethod, String subtotal, String discountAmount, String deliveryFee, String bonusUsed, String total, DateTime createdAt, DateTime? scheduledAt, String? deliveryNote, String? cancelledReason, List<OrderItemLine> items, List<OrderStatusEvent> statusHistory
});




}
/// @nodoc
class __$OrderDetailCopyWithImpl<$Res>
    implements _$OrderDetailCopyWith<$Res> {
  __$OrderDetailCopyWithImpl(this._self, this._then);

  final _OrderDetail _self;
  final $Res Function(_OrderDetail) _then;

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? status = null,Object? deliveryMethod = null,Object? paymentMethod = null,Object? subtotal = null,Object? discountAmount = null,Object? deliveryFee = null,Object? bonusUsed = null,Object? total = null,Object? createdAt = null,Object? scheduledAt = freezed,Object? deliveryNote = freezed,Object? cancelledReason = freezed,Object? items = null,Object? statusHistory = null,}) {
  return _then(_OrderDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deliveryMethod: null == deliveryMethod ? _self.deliveryMethod : deliveryMethod // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as String,bonusUsed: null == bonusUsed ? _self.bonusUsed : bonusUsed // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryNote: freezed == deliveryNote ? _self.deliveryNote : deliveryNote // ignore: cast_nullable_to_non_nullable
as String?,cancelledReason: freezed == cancelledReason ? _self.cancelledReason : cancelledReason // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemLine>,statusHistory: null == statusHistory ? _self._statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<OrderStatusEvent>,
  ));
}


}

// dart format on
