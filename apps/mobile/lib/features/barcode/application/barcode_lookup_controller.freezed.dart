// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barcode_lookup_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BarcodeLookupState {

 BarcodeLookupStatus get status; String? get code; ProductDetail? get product; AppException? get error;
/// Create a copy of BarcodeLookupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarcodeLookupStateCopyWith<BarcodeLookupState> get copyWith => _$BarcodeLookupStateCopyWithImpl<BarcodeLookupState>(this as BarcodeLookupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarcodeLookupState&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&(identical(other.product, product) || other.product == product)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,code,product,error);

@override
String toString() {
  return 'BarcodeLookupState(status: $status, code: $code, product: $product, error: $error)';
}


}

/// @nodoc
abstract mixin class $BarcodeLookupStateCopyWith<$Res>  {
  factory $BarcodeLookupStateCopyWith(BarcodeLookupState value, $Res Function(BarcodeLookupState) _then) = _$BarcodeLookupStateCopyWithImpl;
@useResult
$Res call({
 BarcodeLookupStatus status, String? code, ProductDetail? product, AppException? error
});


$ProductDetailCopyWith<$Res>? get product;

}
/// @nodoc
class _$BarcodeLookupStateCopyWithImpl<$Res>
    implements $BarcodeLookupStateCopyWith<$Res> {
  _$BarcodeLookupStateCopyWithImpl(this._self, this._then);

  final BarcodeLookupState _self;
  final $Res Function(BarcodeLookupState) _then;

/// Create a copy of BarcodeLookupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? code = freezed,Object? product = freezed,Object? error = freezed,}) {
  return _then(BarcodeLookupState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BarcodeLookupStatus,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductDetail?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}
/// Create a copy of BarcodeLookupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDetailCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductDetailCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [BarcodeLookupState].
extension BarcodeLookupStatePatterns on BarcodeLookupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarcodeLookupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarcodeLookupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarcodeLookupState value)  $default,){
final _that = this;
switch (_that) {
case _BarcodeLookupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarcodeLookupState value)?  $default,){
final _that = this;
switch (_that) {
case _BarcodeLookupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BarcodeLookupStatus status,  String? code,  ProductDetail? product,  AppException? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarcodeLookupState() when $default != null:
return $default(_that.status,_that.code,_that.product,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BarcodeLookupStatus status,  String? code,  ProductDetail? product,  AppException? error)  $default,) {final _that = this;
switch (_that) {
case _BarcodeLookupState():
return $default(_that.status,_that.code,_that.product,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BarcodeLookupStatus status,  String? code,  ProductDetail? product,  AppException? error)?  $default,) {final _that = this;
switch (_that) {
case _BarcodeLookupState() when $default != null:
return $default(_that.status,_that.code,_that.product,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _BarcodeLookupState implements BarcodeLookupState {
  const _BarcodeLookupState({this.status = BarcodeLookupStatus.idle, this.code, this.product, this.error});
  

@override@JsonKey() final  BarcodeLookupStatus status;
@override final  String? code;
@override final  ProductDetail? product;
@override final  AppException? error;

/// Create a copy of BarcodeLookupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarcodeLookupStateCopyWith<_BarcodeLookupState> get copyWith => __$BarcodeLookupStateCopyWithImpl<_BarcodeLookupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarcodeLookupState&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&(identical(other.product, product) || other.product == product)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,code,product,error);

@override
String toString() {
  return 'BarcodeLookupState(status: $status, code: $code, product: $product, error: $error)';
}


}

/// @nodoc
abstract mixin class _$BarcodeLookupStateCopyWith<$Res> implements $BarcodeLookupStateCopyWith<$Res> {
  factory _$BarcodeLookupStateCopyWith(_BarcodeLookupState value, $Res Function(_BarcodeLookupState) _then) = __$BarcodeLookupStateCopyWithImpl;
@override @useResult
$Res call({
 BarcodeLookupStatus status, String? code, ProductDetail? product, AppException? error
});


@override $ProductDetailCopyWith<$Res>? get product;

}
/// @nodoc
class __$BarcodeLookupStateCopyWithImpl<$Res>
    implements _$BarcodeLookupStateCopyWith<$Res> {
  __$BarcodeLookupStateCopyWithImpl(this._self, this._then);

  final _BarcodeLookupState _self;
  final $Res Function(_BarcodeLookupState) _then;

/// Create a copy of BarcodeLookupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? code = freezed,Object? product = freezed,Object? error = freezed,}) {
  return _then(_BarcodeLookupState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BarcodeLookupStatus,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductDetail?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}

/// Create a copy of BarcodeLookupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDetailCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductDetailCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on
