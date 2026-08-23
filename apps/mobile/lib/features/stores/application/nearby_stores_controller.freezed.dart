// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_stores_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NearbyStoresState {

 LocationUiStatus get status; double? get lat; double? get lng; List<Store> get stores; AppException? get error;
/// Create a copy of NearbyStoresState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyStoresStateCopyWith<NearbyStoresState> get copyWith => _$NearbyStoresStateCopyWithImpl<NearbyStoresState>(this as NearbyStoresState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyStoresState&&(identical(other.status, status) || other.status == status)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&const DeepCollectionEquality().equals(other.stores, stores)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,lat,lng,const DeepCollectionEquality().hash(stores),error);

@override
String toString() {
  return 'NearbyStoresState(status: $status, lat: $lat, lng: $lng, stores: $stores, error: $error)';
}


}

/// @nodoc
abstract mixin class $NearbyStoresStateCopyWith<$Res>  {
  factory $NearbyStoresStateCopyWith(NearbyStoresState value, $Res Function(NearbyStoresState) _then) = _$NearbyStoresStateCopyWithImpl;
@useResult
$Res call({
 LocationUiStatus status, double? lat, double? lng, List<Store> stores, AppException? error
});




}
/// @nodoc
class _$NearbyStoresStateCopyWithImpl<$Res>
    implements $NearbyStoresStateCopyWith<$Res> {
  _$NearbyStoresStateCopyWithImpl(this._self, this._then);

  final NearbyStoresState _self;
  final $Res Function(NearbyStoresState) _then;

/// Create a copy of NearbyStoresState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? lat = freezed,Object? lng = freezed,Object? stores = null,Object? error = freezed,}) {
  return _then(NearbyStoresState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LocationUiStatus,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,stores: null == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}

}


/// Adds pattern-matching-related methods to [NearbyStoresState].
extension NearbyStoresStatePatterns on NearbyStoresState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyStoresState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyStoresState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyStoresState value)  $default,){
final _that = this;
switch (_that) {
case _NearbyStoresState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyStoresState value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyStoresState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocationUiStatus status,  double? lat,  double? lng,  List<Store> stores,  AppException? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyStoresState() when $default != null:
return $default(_that.status,_that.lat,_that.lng,_that.stores,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocationUiStatus status,  double? lat,  double? lng,  List<Store> stores,  AppException? error)  $default,) {final _that = this;
switch (_that) {
case _NearbyStoresState():
return $default(_that.status,_that.lat,_that.lng,_that.stores,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocationUiStatus status,  double? lat,  double? lng,  List<Store> stores,  AppException? error)?  $default,) {final _that = this;
switch (_that) {
case _NearbyStoresState() when $default != null:
return $default(_that.status,_that.lat,_that.lng,_that.stores,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _NearbyStoresState implements NearbyStoresState {
  const _NearbyStoresState({this.status = LocationUiStatus.idle, this.lat, this.lng,  List<Store> stores = const <Store>[], this.error}): _stores = stores;
  

@override@JsonKey() final  LocationUiStatus status;
@override final  double? lat;
@override final  double? lng;
 final  List<Store> _stores;
@override@JsonKey() List<Store> get stores {
  if (_stores is EqualUnmodifiableListView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stores);
}

@override final  AppException? error;

/// Create a copy of NearbyStoresState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyStoresStateCopyWith<_NearbyStoresState> get copyWith => __$NearbyStoresStateCopyWithImpl<_NearbyStoresState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyStoresState&&(identical(other.status, status) || other.status == status)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&const DeepCollectionEquality().equals(other._stores, _stores)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,lat,lng,const DeepCollectionEquality().hash(_stores),error);

@override
String toString() {
  return 'NearbyStoresState(status: $status, lat: $lat, lng: $lng, stores: $stores, error: $error)';
}


}

/// @nodoc
abstract mixin class _$NearbyStoresStateCopyWith<$Res> implements $NearbyStoresStateCopyWith<$Res> {
  factory _$NearbyStoresStateCopyWith(_NearbyStoresState value, $Res Function(_NearbyStoresState) _then) = __$NearbyStoresStateCopyWithImpl;
@override @useResult
$Res call({
 LocationUiStatus status, double? lat, double? lng, List<Store> stores, AppException? error
});




}
/// @nodoc
class __$NearbyStoresStateCopyWithImpl<$Res>
    implements _$NearbyStoresStateCopyWith<$Res> {
  __$NearbyStoresStateCopyWithImpl(this._self, this._then);

  final _NearbyStoresState _self;
  final $Res Function(_NearbyStoresState) _then;

/// Create a copy of NearbyStoresState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? lat = freezed,Object? lng = freezed,Object? stores = null,Object? error = freezed,}) {
  return _then(_NearbyStoresState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LocationUiStatus,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}


}

// dart format on
