// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Address {

 String get id;/// ISO country code of the market this address is in ('TJ' or 'RU').
/// Defaults to Tajikistan, which is what every address saved before the
/// app served two countries actually is.
 String get country; String get city; String get street; String? get house; String? get apartment; String? get entrance; String? get floor; String? get comment; double? get lat; double? get lng; bool get isDefault;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);

  /// Serializes this Address to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.id, id) || other.id == id)&&(identical(other.country, country) || other.country == country)&&(identical(other.city, city) || other.city == city)&&(identical(other.street, street) || other.street == street)&&(identical(other.house, house) || other.house == house)&&(identical(other.apartment, apartment) || other.apartment == apartment)&&(identical(other.entrance, entrance) || other.entrance == entrance)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,country,city,street,house,apartment,entrance,floor,comment,lat,lng,isDefault);

@override
String toString() {
  return 'Address(id: $id, country: $country, city: $city, street: $street, house: $house, apartment: $apartment, entrance: $entrance, floor: $floor, comment: $comment, lat: $lat, lng: $lng, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 String id, String country, String city, String street, String? house, String? apartment, String? entrance, String? floor, String? comment, double? lat, double? lng, bool isDefault
});




}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? country = null,Object? city = null,Object? street = null,Object? house = freezed,Object? apartment = freezed,Object? entrance = freezed,Object? floor = freezed,Object? comment = freezed,Object? lat = freezed,Object? lng = freezed,Object? isDefault = null,}) {
  return _then(Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,house: freezed == house ? _self.house : house // ignore: cast_nullable_to_non_nullable
as String?,apartment: freezed == apartment ? _self.apartment : apartment // ignore: cast_nullable_to_non_nullable
as String?,entrance: freezed == entrance ? _self.entrance : entrance // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String country,  String city,  String street,  String? house,  String? apartment,  String? entrance,  String? floor,  String? comment,  double? lat,  double? lng,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.country,_that.city,_that.street,_that.house,_that.apartment,_that.entrance,_that.floor,_that.comment,_that.lat,_that.lng,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String country,  String city,  String street,  String? house,  String? apartment,  String? entrance,  String? floor,  String? comment,  double? lat,  double? lng,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.id,_that.country,_that.city,_that.street,_that.house,_that.apartment,_that.entrance,_that.floor,_that.comment,_that.lat,_that.lng,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String country,  String city,  String street,  String? house,  String? apartment,  String? entrance,  String? floor,  String? comment,  double? lat,  double? lng,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.country,_that.city,_that.street,_that.house,_that.apartment,_that.entrance,_that.floor,_that.comment,_that.lat,_that.lng,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Address extends Address {
  const _Address({required this.id, this.country = 'TJ', required this.city, required this.street, this.house, this.apartment, this.entrance, this.floor, this.comment, this.lat, this.lng, this.isDefault = false}): super._();
  factory _Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

@override final  String id;
/// ISO country code of the market this address is in ('TJ' or 'RU').
/// Defaults to Tajikistan, which is what every address saved before the
/// app served two countries actually is.
@override@JsonKey() final  String country;
@override final  String city;
@override final  String street;
@override final  String? house;
@override final  String? apartment;
@override final  String? entrance;
@override final  String? floor;
@override final  String? comment;
@override final  double? lat;
@override final  double? lng;
@override@JsonKey() final  bool isDefault;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.id, id) || other.id == id)&&(identical(other.country, country) || other.country == country)&&(identical(other.city, city) || other.city == city)&&(identical(other.street, street) || other.street == street)&&(identical(other.house, house) || other.house == house)&&(identical(other.apartment, apartment) || other.apartment == apartment)&&(identical(other.entrance, entrance) || other.entrance == entrance)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,country,city,street,house,apartment,entrance,floor,comment,lat,lng,isDefault);

@override
String toString() {
  return 'Address(id: $id, country: $country, city: $city, street: $street, house: $house, apartment: $apartment, entrance: $entrance, floor: $floor, comment: $comment, lat: $lat, lng: $lng, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 String id, String country, String city, String street, String? house, String? apartment, String? entrance, String? floor, String? comment, double? lat, double? lng, bool isDefault
});




}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? country = null,Object? city = null,Object? street = null,Object? house = freezed,Object? apartment = freezed,Object? entrance = freezed,Object? floor = freezed,Object? comment = freezed,Object? lat = freezed,Object? lng = freezed,Object? isDefault = null,}) {
  return _then(_Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,house: freezed == house ? _self.house : house // ignore: cast_nullable_to_non_nullable
as String?,apartment: freezed == apartment ? _self.apartment : apartment // ignore: cast_nullable_to_non_nullable
as String?,entrance: freezed == entrance ? _self.entrance : entrance // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
