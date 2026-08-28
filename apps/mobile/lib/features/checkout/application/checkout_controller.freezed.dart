// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutState {

 AsyncValue<List<Address>> get addresses; String? get selectedAddressId; DeliveryMethod get deliveryMethod; bool get isAsap; DateTime? get scheduledAt; String get paymentMethod; String? get promoCode; AsyncValue<CheckoutQuote> get quote; bool get isPlacingOrder; AppException? get placeOrderError; PlacedOrder? get placedOrder; String? get idempotencyKey;
/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutStateCopyWith<CheckoutState> get copyWith => _$CheckoutStateCopyWithImpl<CheckoutState>(this as CheckoutState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutState&&(identical(other.addresses, addresses) || other.addresses == addresses)&&(identical(other.selectedAddressId, selectedAddressId) || other.selectedAddressId == selectedAddressId)&&(identical(other.deliveryMethod, deliveryMethod) || other.deliveryMethod == deliveryMethod)&&(identical(other.isAsap, isAsap) || other.isAsap == isAsap)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.isPlacingOrder, isPlacingOrder) || other.isPlacingOrder == isPlacingOrder)&&(identical(other.placeOrderError, placeOrderError) || other.placeOrderError == placeOrderError)&&(identical(other.placedOrder, placedOrder) || other.placedOrder == placedOrder)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey));
}


@override
int get hashCode => Object.hash(runtimeType,addresses,selectedAddressId,deliveryMethod,isAsap,scheduledAt,paymentMethod,promoCode,quote,isPlacingOrder,placeOrderError,placedOrder,idempotencyKey);

@override
String toString() {
  return 'CheckoutState(addresses: $addresses, selectedAddressId: $selectedAddressId, deliveryMethod: $deliveryMethod, isAsap: $isAsap, scheduledAt: $scheduledAt, paymentMethod: $paymentMethod, promoCode: $promoCode, quote: $quote, isPlacingOrder: $isPlacingOrder, placeOrderError: $placeOrderError, placedOrder: $placedOrder, idempotencyKey: $idempotencyKey)';
}


}

/// @nodoc
abstract mixin class $CheckoutStateCopyWith<$Res>  {
  factory $CheckoutStateCopyWith(CheckoutState value, $Res Function(CheckoutState) _then) = _$CheckoutStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<Address>> addresses, String? selectedAddressId, DeliveryMethod deliveryMethod, bool isAsap, DateTime? scheduledAt, String paymentMethod, String? promoCode, AsyncValue<CheckoutQuote> quote, bool isPlacingOrder, AppException? placeOrderError, PlacedOrder? placedOrder, String? idempotencyKey
});


$PlacedOrderCopyWith<$Res>? get placedOrder;

}
/// @nodoc
class _$CheckoutStateCopyWithImpl<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  _$CheckoutStateCopyWithImpl(this._self, this._then);

  final CheckoutState _self;
  final $Res Function(CheckoutState) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? addresses = null,Object? selectedAddressId = freezed,Object? deliveryMethod = null,Object? isAsap = null,Object? scheduledAt = freezed,Object? paymentMethod = null,Object? promoCode = freezed,Object? quote = null,Object? isPlacingOrder = null,Object? placeOrderError = freezed,Object? placedOrder = freezed,Object? idempotencyKey = freezed,}) {
  return _then(CheckoutState(
addresses: null == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<Address>>,selectedAddressId: freezed == selectedAddressId ? _self.selectedAddressId : selectedAddressId // ignore: cast_nullable_to_non_nullable
as String?,deliveryMethod: null == deliveryMethod ? _self.deliveryMethod : deliveryMethod // ignore: cast_nullable_to_non_nullable
as DeliveryMethod,isAsap: null == isAsap ? _self.isAsap : isAsap // ignore: cast_nullable_to_non_nullable
as bool,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as AsyncValue<CheckoutQuote>,isPlacingOrder: null == isPlacingOrder ? _self.isPlacingOrder : isPlacingOrder // ignore: cast_nullable_to_non_nullable
as bool,placeOrderError: freezed == placeOrderError ? _self.placeOrderError : placeOrderError // ignore: cast_nullable_to_non_nullable
as AppException?,placedOrder: freezed == placedOrder ? _self.placedOrder : placedOrder // ignore: cast_nullable_to_non_nullable
as PlacedOrder?,idempotencyKey: freezed == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacedOrderCopyWith<$Res>? get placedOrder {
    if (_self.placedOrder == null) {
    return null;
  }

  return $PlacedOrderCopyWith<$Res>(_self.placedOrder!, (value) {
    return _then(_self.copyWith(placedOrder: value));
  });
}
}


/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutState value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutState value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<Address>> addresses,  String? selectedAddressId,  DeliveryMethod deliveryMethod,  bool isAsap,  DateTime? scheduledAt,  String paymentMethod,  String? promoCode,  AsyncValue<CheckoutQuote> quote,  bool isPlacingOrder,  AppException? placeOrderError,  PlacedOrder? placedOrder,  String? idempotencyKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
return $default(_that.addresses,_that.selectedAddressId,_that.deliveryMethod,_that.isAsap,_that.scheduledAt,_that.paymentMethod,_that.promoCode,_that.quote,_that.isPlacingOrder,_that.placeOrderError,_that.placedOrder,_that.idempotencyKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<Address>> addresses,  String? selectedAddressId,  DeliveryMethod deliveryMethod,  bool isAsap,  DateTime? scheduledAt,  String paymentMethod,  String? promoCode,  AsyncValue<CheckoutQuote> quote,  bool isPlacingOrder,  AppException? placeOrderError,  PlacedOrder? placedOrder,  String? idempotencyKey)  $default,) {final _that = this;
switch (_that) {
case _CheckoutState():
return $default(_that.addresses,_that.selectedAddressId,_that.deliveryMethod,_that.isAsap,_that.scheduledAt,_that.paymentMethod,_that.promoCode,_that.quote,_that.isPlacingOrder,_that.placeOrderError,_that.placedOrder,_that.idempotencyKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<Address>> addresses,  String? selectedAddressId,  DeliveryMethod deliveryMethod,  bool isAsap,  DateTime? scheduledAt,  String paymentMethod,  String? promoCode,  AsyncValue<CheckoutQuote> quote,  bool isPlacingOrder,  AppException? placeOrderError,  PlacedOrder? placedOrder,  String? idempotencyKey)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
return $default(_that.addresses,_that.selectedAddressId,_that.deliveryMethod,_that.isAsap,_that.scheduledAt,_that.paymentMethod,_that.promoCode,_that.quote,_that.isPlacingOrder,_that.placeOrderError,_that.placedOrder,_that.idempotencyKey);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutState implements CheckoutState {
  const _CheckoutState({this.addresses = const AsyncValue.loading(), this.selectedAddressId, this.deliveryMethod = DeliveryMethod.delivery, this.isAsap = true, this.scheduledAt, this.paymentMethod = kCashOnDeliveryMethod, this.promoCode, this.quote = const AsyncValue<CheckoutQuote>.loading(), this.isPlacingOrder = false, this.placeOrderError, this.placedOrder, this.idempotencyKey});
  

@override@JsonKey() final  AsyncValue<List<Address>> addresses;
@override final  String? selectedAddressId;
@override@JsonKey() final  DeliveryMethod deliveryMethod;
@override@JsonKey() final  bool isAsap;
@override final  DateTime? scheduledAt;
@override@JsonKey() final  String paymentMethod;
@override final  String? promoCode;
@override@JsonKey() final  AsyncValue<CheckoutQuote> quote;
@override@JsonKey() final  bool isPlacingOrder;
@override final  AppException? placeOrderError;
@override final  PlacedOrder? placedOrder;
@override final  String? idempotencyKey;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutStateCopyWith<_CheckoutState> get copyWith => __$CheckoutStateCopyWithImpl<_CheckoutState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutState&&(identical(other.addresses, addresses) || other.addresses == addresses)&&(identical(other.selectedAddressId, selectedAddressId) || other.selectedAddressId == selectedAddressId)&&(identical(other.deliveryMethod, deliveryMethod) || other.deliveryMethod == deliveryMethod)&&(identical(other.isAsap, isAsap) || other.isAsap == isAsap)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.isPlacingOrder, isPlacingOrder) || other.isPlacingOrder == isPlacingOrder)&&(identical(other.placeOrderError, placeOrderError) || other.placeOrderError == placeOrderError)&&(identical(other.placedOrder, placedOrder) || other.placedOrder == placedOrder)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey));
}


@override
int get hashCode => Object.hash(runtimeType,addresses,selectedAddressId,deliveryMethod,isAsap,scheduledAt,paymentMethod,promoCode,quote,isPlacingOrder,placeOrderError,placedOrder,idempotencyKey);

@override
String toString() {
  return 'CheckoutState(addresses: $addresses, selectedAddressId: $selectedAddressId, deliveryMethod: $deliveryMethod, isAsap: $isAsap, scheduledAt: $scheduledAt, paymentMethod: $paymentMethod, promoCode: $promoCode, quote: $quote, isPlacingOrder: $isPlacingOrder, placeOrderError: $placeOrderError, placedOrder: $placedOrder, idempotencyKey: $idempotencyKey)';
}


}

/// @nodoc
abstract mixin class _$CheckoutStateCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$CheckoutStateCopyWith(_CheckoutState value, $Res Function(_CheckoutState) _then) = __$CheckoutStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<Address>> addresses, String? selectedAddressId, DeliveryMethod deliveryMethod, bool isAsap, DateTime? scheduledAt, String paymentMethod, String? promoCode, AsyncValue<CheckoutQuote> quote, bool isPlacingOrder, AppException? placeOrderError, PlacedOrder? placedOrder, String? idempotencyKey
});


@override $PlacedOrderCopyWith<$Res>? get placedOrder;

}
/// @nodoc
class __$CheckoutStateCopyWithImpl<$Res>
    implements _$CheckoutStateCopyWith<$Res> {
  __$CheckoutStateCopyWithImpl(this._self, this._then);

  final _CheckoutState _self;
  final $Res Function(_CheckoutState) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? addresses = null,Object? selectedAddressId = freezed,Object? deliveryMethod = null,Object? isAsap = null,Object? scheduledAt = freezed,Object? paymentMethod = null,Object? promoCode = freezed,Object? quote = null,Object? isPlacingOrder = null,Object? placeOrderError = freezed,Object? placedOrder = freezed,Object? idempotencyKey = freezed,}) {
  return _then(_CheckoutState(
addresses: null == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<Address>>,selectedAddressId: freezed == selectedAddressId ? _self.selectedAddressId : selectedAddressId // ignore: cast_nullable_to_non_nullable
as String?,deliveryMethod: null == deliveryMethod ? _self.deliveryMethod : deliveryMethod // ignore: cast_nullable_to_non_nullable
as DeliveryMethod,isAsap: null == isAsap ? _self.isAsap : isAsap // ignore: cast_nullable_to_non_nullable
as bool,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,promoCode: freezed == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String?,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as AsyncValue<CheckoutQuote>,isPlacingOrder: null == isPlacingOrder ? _self.isPlacingOrder : isPlacingOrder // ignore: cast_nullable_to_non_nullable
as bool,placeOrderError: freezed == placeOrderError ? _self.placeOrderError : placeOrderError // ignore: cast_nullable_to_non_nullable
as AppException?,placedOrder: freezed == placedOrder ? _self.placedOrder : placedOrder // ignore: cast_nullable_to_non_nullable
as PlacedOrder?,idempotencyKey: freezed == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacedOrderCopyWith<$Res>? get placedOrder {
    if (_self.placedOrder == null) {
    return null;
  }

  return $PlacedOrderCopyWith<$Res>(_self.placedOrder!, (value) {
    return _then(_self.copyWith(placedOrder: value));
  });
}
}

// dart format on
