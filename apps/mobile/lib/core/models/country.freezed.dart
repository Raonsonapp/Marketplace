// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$City {

 String get id;@JsonKey(name: 'name_tg') String get nameTg;@JsonKey(name: 'name_ru') String get nameRu;@JsonKey(name: 'name_en') String get nameEn; double get lat; double get lng;
/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityCopyWith<City> get copyWith => _$CityCopyWithImpl<City>(this as City, _$identity);

  /// Serializes this City to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is City&&(identical(other.id, id) || other.id == id)&&(identical(other.nameTg, nameTg) || other.nameTg == nameTg)&&(identical(other.nameRu, nameRu) || other.nameRu == nameRu)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameTg,nameRu,nameEn,lat,lng);

@override
String toString() {
  return 'City(id: $id, nameTg: $nameTg, nameRu: $nameRu, nameEn: $nameEn, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $CityCopyWith<$Res>  {
  factory $CityCopyWith(City value, $Res Function(City) _then) = _$CityCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'name_tg') String nameTg,@JsonKey(name: 'name_ru') String nameRu,@JsonKey(name: 'name_en') String nameEn, double lat, double lng
});




}
/// @nodoc
class _$CityCopyWithImpl<$Res>
    implements $CityCopyWith<$Res> {
  _$CityCopyWithImpl(this._self, this._then);

  final City _self;
  final $Res Function(City) _then;

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameTg = null,Object? nameRu = null,Object? nameEn = null,Object? lat = null,Object? lng = null,}) {
  return _then(City(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameTg: null == nameTg ? _self.nameTg : nameTg // ignore: cast_nullable_to_non_nullable
as String,nameRu: null == nameRu ? _self.nameRu : nameRu // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [City].
extension CityPatterns on City {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _City value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _City() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _City value)  $default,){
final _that = this;
switch (_that) {
case _City():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _City value)?  $default,){
final _that = this;
switch (_that) {
case _City() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'name_tg')  String nameTg, @JsonKey(name: 'name_ru')  String nameRu, @JsonKey(name: 'name_en')  String nameEn,  double lat,  double lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _City() when $default != null:
return $default(_that.id,_that.nameTg,_that.nameRu,_that.nameEn,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'name_tg')  String nameTg, @JsonKey(name: 'name_ru')  String nameRu, @JsonKey(name: 'name_en')  String nameEn,  double lat,  double lng)  $default,) {final _that = this;
switch (_that) {
case _City():
return $default(_that.id,_that.nameTg,_that.nameRu,_that.nameEn,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'name_tg')  String nameTg, @JsonKey(name: 'name_ru')  String nameRu, @JsonKey(name: 'name_en')  String nameEn,  double lat,  double lng)?  $default,) {final _that = this;
switch (_that) {
case _City() when $default != null:
return $default(_that.id,_that.nameTg,_that.nameRu,_that.nameEn,_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _City extends City {
  const _City({required this.id, @JsonKey(name: 'name_tg') required this.nameTg, @JsonKey(name: 'name_ru') required this.nameRu, @JsonKey(name: 'name_en') required this.nameEn, required this.lat, required this.lng}): super._();
  factory _City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

@override final  String id;
@override@JsonKey(name: 'name_tg') final  String nameTg;
@override@JsonKey(name: 'name_ru') final  String nameRu;
@override@JsonKey(name: 'name_en') final  String nameEn;
@override final  double lat;
@override final  double lng;

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityCopyWith<_City> get copyWith => __$CityCopyWithImpl<_City>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _City&&(identical(other.id, id) || other.id == id)&&(identical(other.nameTg, nameTg) || other.nameTg == nameTg)&&(identical(other.nameRu, nameRu) || other.nameRu == nameRu)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameTg,nameRu,nameEn,lat,lng);

@override
String toString() {
  return 'City(id: $id, nameTg: $nameTg, nameRu: $nameRu, nameEn: $nameEn, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$CityCopyWith<$Res> implements $CityCopyWith<$Res> {
  factory _$CityCopyWith(_City value, $Res Function(_City) _then) = __$CityCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'name_tg') String nameTg,@JsonKey(name: 'name_ru') String nameRu,@JsonKey(name: 'name_en') String nameEn, double lat, double lng
});




}
/// @nodoc
class __$CityCopyWithImpl<$Res>
    implements _$CityCopyWith<$Res> {
  __$CityCopyWithImpl(this._self, this._then);

  final _City _self;
  final $Res Function(_City) _then;

/// Create a copy of City
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameTg = null,Object? nameRu = null,Object? nameEn = null,Object? lat = null,Object? lng = null,}) {
  return _then(_City(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameTg: null == nameTg ? _self.nameTg : nameTg // ignore: cast_nullable_to_non_nullable
as String,nameRu: null == nameRu ? _self.nameRu : nameRu // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$Country {

 String get code;@JsonKey(name: 'name_tg') String get nameTg;@JsonKey(name: 'name_ru') String get nameRu;@JsonKey(name: 'name_en') String get nameEn;@JsonKey(name: 'currency_code') String get currencyCode;@JsonKey(name: 'currency_tg') String get currencyTg;@JsonKey(name: 'currency_ru') String get currencyRu;@JsonKey(name: 'currency_en') String get currencyEn;@JsonKey(name: 'dial_code') String get dialCode;@JsonKey(name: 'center_lat') double get centerLat;@JsonKey(name: 'center_lng') double get centerLng; List<City> get cities;
/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryCopyWith<Country> get copyWith => _$CountryCopyWithImpl<Country>(this as Country, _$identity);

  /// Serializes this Country to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Country&&(identical(other.code, code) || other.code == code)&&(identical(other.nameTg, nameTg) || other.nameTg == nameTg)&&(identical(other.nameRu, nameRu) || other.nameRu == nameRu)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.currencyTg, currencyTg) || other.currencyTg == currencyTg)&&(identical(other.currencyRu, currencyRu) || other.currencyRu == currencyRu)&&(identical(other.currencyEn, currencyEn) || other.currencyEn == currencyEn)&&(identical(other.dialCode, dialCode) || other.dialCode == dialCode)&&(identical(other.centerLat, centerLat) || other.centerLat == centerLat)&&(identical(other.centerLng, centerLng) || other.centerLng == centerLng)&&const DeepCollectionEquality().equals(other.cities, cities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,nameTg,nameRu,nameEn,currencyCode,currencyTg,currencyRu,currencyEn,dialCode,centerLat,centerLng,const DeepCollectionEquality().hash(cities));

@override
String toString() {
  return 'Country(code: $code, nameTg: $nameTg, nameRu: $nameRu, nameEn: $nameEn, currencyCode: $currencyCode, currencyTg: $currencyTg, currencyRu: $currencyRu, currencyEn: $currencyEn, dialCode: $dialCode, centerLat: $centerLat, centerLng: $centerLng, cities: $cities)';
}


}

/// @nodoc
abstract mixin class $CountryCopyWith<$Res>  {
  factory $CountryCopyWith(Country value, $Res Function(Country) _then) = _$CountryCopyWithImpl;
@useResult
$Res call({
 String code,@JsonKey(name: 'name_tg') String nameTg,@JsonKey(name: 'name_ru') String nameRu,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'currency_code') String currencyCode,@JsonKey(name: 'currency_tg') String currencyTg,@JsonKey(name: 'currency_ru') String currencyRu,@JsonKey(name: 'currency_en') String currencyEn,@JsonKey(name: 'dial_code') String dialCode,@JsonKey(name: 'center_lat') double centerLat,@JsonKey(name: 'center_lng') double centerLng, List<City> cities
});




}
/// @nodoc
class _$CountryCopyWithImpl<$Res>
    implements $CountryCopyWith<$Res> {
  _$CountryCopyWithImpl(this._self, this._then);

  final Country _self;
  final $Res Function(Country) _then;

/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? nameTg = null,Object? nameRu = null,Object? nameEn = null,Object? currencyCode = null,Object? currencyTg = null,Object? currencyRu = null,Object? currencyEn = null,Object? dialCode = null,Object? centerLat = null,Object? centerLng = null,Object? cities = null,}) {
  return _then(Country(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameTg: null == nameTg ? _self.nameTg : nameTg // ignore: cast_nullable_to_non_nullable
as String,nameRu: null == nameRu ? _self.nameRu : nameRu // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,currencyTg: null == currencyTg ? _self.currencyTg : currencyTg // ignore: cast_nullable_to_non_nullable
as String,currencyRu: null == currencyRu ? _self.currencyRu : currencyRu // ignore: cast_nullable_to_non_nullable
as String,currencyEn: null == currencyEn ? _self.currencyEn : currencyEn // ignore: cast_nullable_to_non_nullable
as String,dialCode: null == dialCode ? _self.dialCode : dialCode // ignore: cast_nullable_to_non_nullable
as String,centerLat: null == centerLat ? _self.centerLat : centerLat // ignore: cast_nullable_to_non_nullable
as double,centerLng: null == centerLng ? _self.centerLng : centerLng // ignore: cast_nullable_to_non_nullable
as double,cities: null == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as List<City>,
  ));
}

}


/// Adds pattern-matching-related methods to [Country].
extension CountryPatterns on Country {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Country value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Country() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Country value)  $default,){
final _that = this;
switch (_that) {
case _Country():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Country value)?  $default,){
final _that = this;
switch (_that) {
case _Country() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code, @JsonKey(name: 'name_tg')  String nameTg, @JsonKey(name: 'name_ru')  String nameRu, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'currency_code')  String currencyCode, @JsonKey(name: 'currency_tg')  String currencyTg, @JsonKey(name: 'currency_ru')  String currencyRu, @JsonKey(name: 'currency_en')  String currencyEn, @JsonKey(name: 'dial_code')  String dialCode, @JsonKey(name: 'center_lat')  double centerLat, @JsonKey(name: 'center_lng')  double centerLng,  List<City> cities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Country() when $default != null:
return $default(_that.code,_that.nameTg,_that.nameRu,_that.nameEn,_that.currencyCode,_that.currencyTg,_that.currencyRu,_that.currencyEn,_that.dialCode,_that.centerLat,_that.centerLng,_that.cities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code, @JsonKey(name: 'name_tg')  String nameTg, @JsonKey(name: 'name_ru')  String nameRu, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'currency_code')  String currencyCode, @JsonKey(name: 'currency_tg')  String currencyTg, @JsonKey(name: 'currency_ru')  String currencyRu, @JsonKey(name: 'currency_en')  String currencyEn, @JsonKey(name: 'dial_code')  String dialCode, @JsonKey(name: 'center_lat')  double centerLat, @JsonKey(name: 'center_lng')  double centerLng,  List<City> cities)  $default,) {final _that = this;
switch (_that) {
case _Country():
return $default(_that.code,_that.nameTg,_that.nameRu,_that.nameEn,_that.currencyCode,_that.currencyTg,_that.currencyRu,_that.currencyEn,_that.dialCode,_that.centerLat,_that.centerLng,_that.cities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code, @JsonKey(name: 'name_tg')  String nameTg, @JsonKey(name: 'name_ru')  String nameRu, @JsonKey(name: 'name_en')  String nameEn, @JsonKey(name: 'currency_code')  String currencyCode, @JsonKey(name: 'currency_tg')  String currencyTg, @JsonKey(name: 'currency_ru')  String currencyRu, @JsonKey(name: 'currency_en')  String currencyEn, @JsonKey(name: 'dial_code')  String dialCode, @JsonKey(name: 'center_lat')  double centerLat, @JsonKey(name: 'center_lng')  double centerLng,  List<City> cities)?  $default,) {final _that = this;
switch (_that) {
case _Country() when $default != null:
return $default(_that.code,_that.nameTg,_that.nameRu,_that.nameEn,_that.currencyCode,_that.currencyTg,_that.currencyRu,_that.currencyEn,_that.dialCode,_that.centerLat,_that.centerLng,_that.cities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Country extends Country {
  const _Country({required this.code, @JsonKey(name: 'name_tg') required this.nameTg, @JsonKey(name: 'name_ru') required this.nameRu, @JsonKey(name: 'name_en') required this.nameEn, @JsonKey(name: 'currency_code') required this.currencyCode, @JsonKey(name: 'currency_tg') required this.currencyTg, @JsonKey(name: 'currency_ru') required this.currencyRu, @JsonKey(name: 'currency_en') required this.currencyEn, @JsonKey(name: 'dial_code') required this.dialCode, @JsonKey(name: 'center_lat') required this.centerLat, @JsonKey(name: 'center_lng') required this.centerLng,  List<City> cities = const <City>[]}): _cities = cities,super._();
  factory _Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

@override final  String code;
@override@JsonKey(name: 'name_tg') final  String nameTg;
@override@JsonKey(name: 'name_ru') final  String nameRu;
@override@JsonKey(name: 'name_en') final  String nameEn;
@override@JsonKey(name: 'currency_code') final  String currencyCode;
@override@JsonKey(name: 'currency_tg') final  String currencyTg;
@override@JsonKey(name: 'currency_ru') final  String currencyRu;
@override@JsonKey(name: 'currency_en') final  String currencyEn;
@override@JsonKey(name: 'dial_code') final  String dialCode;
@override@JsonKey(name: 'center_lat') final  double centerLat;
@override@JsonKey(name: 'center_lng') final  double centerLng;
 final  List<City> _cities;
@override@JsonKey() List<City> get cities {
  if (_cities is EqualUnmodifiableListView) return _cities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cities);
}


/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountryCopyWith<_Country> get copyWith => __$CountryCopyWithImpl<_Country>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CountryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Country&&(identical(other.code, code) || other.code == code)&&(identical(other.nameTg, nameTg) || other.nameTg == nameTg)&&(identical(other.nameRu, nameRu) || other.nameRu == nameRu)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.currencyTg, currencyTg) || other.currencyTg == currencyTg)&&(identical(other.currencyRu, currencyRu) || other.currencyRu == currencyRu)&&(identical(other.currencyEn, currencyEn) || other.currencyEn == currencyEn)&&(identical(other.dialCode, dialCode) || other.dialCode == dialCode)&&(identical(other.centerLat, centerLat) || other.centerLat == centerLat)&&(identical(other.centerLng, centerLng) || other.centerLng == centerLng)&&const DeepCollectionEquality().equals(other._cities, _cities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,nameTg,nameRu,nameEn,currencyCode,currencyTg,currencyRu,currencyEn,dialCode,centerLat,centerLng,const DeepCollectionEquality().hash(_cities));

@override
String toString() {
  return 'Country(code: $code, nameTg: $nameTg, nameRu: $nameRu, nameEn: $nameEn, currencyCode: $currencyCode, currencyTg: $currencyTg, currencyRu: $currencyRu, currencyEn: $currencyEn, dialCode: $dialCode, centerLat: $centerLat, centerLng: $centerLng, cities: $cities)';
}


}

/// @nodoc
abstract mixin class _$CountryCopyWith<$Res> implements $CountryCopyWith<$Res> {
  factory _$CountryCopyWith(_Country value, $Res Function(_Country) _then) = __$CountryCopyWithImpl;
@override @useResult
$Res call({
 String code,@JsonKey(name: 'name_tg') String nameTg,@JsonKey(name: 'name_ru') String nameRu,@JsonKey(name: 'name_en') String nameEn,@JsonKey(name: 'currency_code') String currencyCode,@JsonKey(name: 'currency_tg') String currencyTg,@JsonKey(name: 'currency_ru') String currencyRu,@JsonKey(name: 'currency_en') String currencyEn,@JsonKey(name: 'dial_code') String dialCode,@JsonKey(name: 'center_lat') double centerLat,@JsonKey(name: 'center_lng') double centerLng, List<City> cities
});




}
/// @nodoc
class __$CountryCopyWithImpl<$Res>
    implements _$CountryCopyWith<$Res> {
  __$CountryCopyWithImpl(this._self, this._then);

  final _Country _self;
  final $Res Function(_Country) _then;

/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? nameTg = null,Object? nameRu = null,Object? nameEn = null,Object? currencyCode = null,Object? currencyTg = null,Object? currencyRu = null,Object? currencyEn = null,Object? dialCode = null,Object? centerLat = null,Object? centerLng = null,Object? cities = null,}) {
  return _then(_Country(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameTg: null == nameTg ? _self.nameTg : nameTg // ignore: cast_nullable_to_non_nullable
as String,nameRu: null == nameRu ? _self.nameRu : nameRu // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,currencyTg: null == currencyTg ? _self.currencyTg : currencyTg // ignore: cast_nullable_to_non_nullable
as String,currencyRu: null == currencyRu ? _self.currencyRu : currencyRu // ignore: cast_nullable_to_non_nullable
as String,currencyEn: null == currencyEn ? _self.currencyEn : currencyEn // ignore: cast_nullable_to_non_nullable
as String,dialCode: null == dialCode ? _self.dialCode : dialCode // ignore: cast_nullable_to_non_nullable
as String,centerLat: null == centerLat ? _self.centerLat : centerLat // ignore: cast_nullable_to_non_nullable
as double,centerLng: null == centerLng ? _self.centerLng : centerLng // ignore: cast_nullable_to_non_nullable
as double,cities: null == cities ? _self._cities : cities // ignore: cast_nullable_to_non_nullable
as List<City>,
  ));
}


}

// dart format on
