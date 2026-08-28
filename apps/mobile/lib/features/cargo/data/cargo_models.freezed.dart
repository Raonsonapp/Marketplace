// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cargo_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CargoTariff {

 String get destination;@JsonKey(name: 'rate_per_kg') String get ratePerKg;@JsonKey(name: 'warehouse_address') String get warehouseAddress;@JsonKey(name: 'contact_phone') String get contactPhone;@JsonKey(name: 'estimated_days_min') int? get estimatedDaysMin;@JsonKey(name: 'estimated_days_max') int? get estimatedDaysMax;
/// Create a copy of CargoTariff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CargoTariffCopyWith<CargoTariff> get copyWith => _$CargoTariffCopyWithImpl<CargoTariff>(this as CargoTariff, _$identity);

  /// Serializes this CargoTariff to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CargoTariff&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.ratePerKg, ratePerKg) || other.ratePerKg == ratePerKg)&&(identical(other.warehouseAddress, warehouseAddress) || other.warehouseAddress == warehouseAddress)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.estimatedDaysMin, estimatedDaysMin) || other.estimatedDaysMin == estimatedDaysMin)&&(identical(other.estimatedDaysMax, estimatedDaysMax) || other.estimatedDaysMax == estimatedDaysMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,destination,ratePerKg,warehouseAddress,contactPhone,estimatedDaysMin,estimatedDaysMax);

@override
String toString() {
  return 'CargoTariff(destination: $destination, ratePerKg: $ratePerKg, warehouseAddress: $warehouseAddress, contactPhone: $contactPhone, estimatedDaysMin: $estimatedDaysMin, estimatedDaysMax: $estimatedDaysMax)';
}


}

/// @nodoc
abstract mixin class $CargoTariffCopyWith<$Res>  {
  factory $CargoTariffCopyWith(CargoTariff value, $Res Function(CargoTariff) _then) = _$CargoTariffCopyWithImpl;
@useResult
$Res call({
 String destination,@JsonKey(name: 'rate_per_kg') String ratePerKg,@JsonKey(name: 'warehouse_address') String warehouseAddress,@JsonKey(name: 'contact_phone') String contactPhone,@JsonKey(name: 'estimated_days_min') int? estimatedDaysMin,@JsonKey(name: 'estimated_days_max') int? estimatedDaysMax
});




}
/// @nodoc
class _$CargoTariffCopyWithImpl<$Res>
    implements $CargoTariffCopyWith<$Res> {
  _$CargoTariffCopyWithImpl(this._self, this._then);

  final CargoTariff _self;
  final $Res Function(CargoTariff) _then;

/// Create a copy of CargoTariff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? destination = null,Object? ratePerKg = null,Object? warehouseAddress = null,Object? contactPhone = null,Object? estimatedDaysMin = freezed,Object? estimatedDaysMax = freezed,}) {
  return _then(CargoTariff(
destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,ratePerKg: null == ratePerKg ? _self.ratePerKg : ratePerKg // ignore: cast_nullable_to_non_nullable
as String,warehouseAddress: null == warehouseAddress ? _self.warehouseAddress : warehouseAddress // ignore: cast_nullable_to_non_nullable
as String,contactPhone: null == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String,estimatedDaysMin: freezed == estimatedDaysMin ? _self.estimatedDaysMin : estimatedDaysMin // ignore: cast_nullable_to_non_nullable
as int?,estimatedDaysMax: freezed == estimatedDaysMax ? _self.estimatedDaysMax : estimatedDaysMax // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CargoTariff].
extension CargoTariffPatterns on CargoTariff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CargoTariff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CargoTariff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CargoTariff value)  $default,){
final _that = this;
switch (_that) {
case _CargoTariff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CargoTariff value)?  $default,){
final _that = this;
switch (_that) {
case _CargoTariff() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String destination, @JsonKey(name: 'rate_per_kg')  String ratePerKg, @JsonKey(name: 'warehouse_address')  String warehouseAddress, @JsonKey(name: 'contact_phone')  String contactPhone, @JsonKey(name: 'estimated_days_min')  int? estimatedDaysMin, @JsonKey(name: 'estimated_days_max')  int? estimatedDaysMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CargoTariff() when $default != null:
return $default(_that.destination,_that.ratePerKg,_that.warehouseAddress,_that.contactPhone,_that.estimatedDaysMin,_that.estimatedDaysMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String destination, @JsonKey(name: 'rate_per_kg')  String ratePerKg, @JsonKey(name: 'warehouse_address')  String warehouseAddress, @JsonKey(name: 'contact_phone')  String contactPhone, @JsonKey(name: 'estimated_days_min')  int? estimatedDaysMin, @JsonKey(name: 'estimated_days_max')  int? estimatedDaysMax)  $default,) {final _that = this;
switch (_that) {
case _CargoTariff():
return $default(_that.destination,_that.ratePerKg,_that.warehouseAddress,_that.contactPhone,_that.estimatedDaysMin,_that.estimatedDaysMax);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String destination, @JsonKey(name: 'rate_per_kg')  String ratePerKg, @JsonKey(name: 'warehouse_address')  String warehouseAddress, @JsonKey(name: 'contact_phone')  String contactPhone, @JsonKey(name: 'estimated_days_min')  int? estimatedDaysMin, @JsonKey(name: 'estimated_days_max')  int? estimatedDaysMax)?  $default,) {final _that = this;
switch (_that) {
case _CargoTariff() when $default != null:
return $default(_that.destination,_that.ratePerKg,_that.warehouseAddress,_that.contactPhone,_that.estimatedDaysMin,_that.estimatedDaysMax);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CargoTariff implements CargoTariff {
  const _CargoTariff({required this.destination, @JsonKey(name: 'rate_per_kg') required this.ratePerKg, @JsonKey(name: 'warehouse_address') this.warehouseAddress = '', @JsonKey(name: 'contact_phone') this.contactPhone = '', @JsonKey(name: 'estimated_days_min') this.estimatedDaysMin, @JsonKey(name: 'estimated_days_max') this.estimatedDaysMax});
  factory _CargoTariff.fromJson(Map<String, dynamic> json) => _$CargoTariffFromJson(json);

@override final  String destination;
@override@JsonKey(name: 'rate_per_kg') final  String ratePerKg;
@override@JsonKey(name: 'warehouse_address') final  String warehouseAddress;
@override@JsonKey(name: 'contact_phone') final  String contactPhone;
@override@JsonKey(name: 'estimated_days_min') final  int? estimatedDaysMin;
@override@JsonKey(name: 'estimated_days_max') final  int? estimatedDaysMax;

/// Create a copy of CargoTariff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CargoTariffCopyWith<_CargoTariff> get copyWith => __$CargoTariffCopyWithImpl<_CargoTariff>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CargoTariffToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CargoTariff&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.ratePerKg, ratePerKg) || other.ratePerKg == ratePerKg)&&(identical(other.warehouseAddress, warehouseAddress) || other.warehouseAddress == warehouseAddress)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.estimatedDaysMin, estimatedDaysMin) || other.estimatedDaysMin == estimatedDaysMin)&&(identical(other.estimatedDaysMax, estimatedDaysMax) || other.estimatedDaysMax == estimatedDaysMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,destination,ratePerKg,warehouseAddress,contactPhone,estimatedDaysMin,estimatedDaysMax);

@override
String toString() {
  return 'CargoTariff(destination: $destination, ratePerKg: $ratePerKg, warehouseAddress: $warehouseAddress, contactPhone: $contactPhone, estimatedDaysMin: $estimatedDaysMin, estimatedDaysMax: $estimatedDaysMax)';
}


}

/// @nodoc
abstract mixin class _$CargoTariffCopyWith<$Res> implements $CargoTariffCopyWith<$Res> {
  factory _$CargoTariffCopyWith(_CargoTariff value, $Res Function(_CargoTariff) _then) = __$CargoTariffCopyWithImpl;
@override @useResult
$Res call({
 String destination,@JsonKey(name: 'rate_per_kg') String ratePerKg,@JsonKey(name: 'warehouse_address') String warehouseAddress,@JsonKey(name: 'contact_phone') String contactPhone,@JsonKey(name: 'estimated_days_min') int? estimatedDaysMin,@JsonKey(name: 'estimated_days_max') int? estimatedDaysMax
});




}
/// @nodoc
class __$CargoTariffCopyWithImpl<$Res>
    implements _$CargoTariffCopyWith<$Res> {
  __$CargoTariffCopyWithImpl(this._self, this._then);

  final _CargoTariff _self;
  final $Res Function(_CargoTariff) _then;

/// Create a copy of CargoTariff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? destination = null,Object? ratePerKg = null,Object? warehouseAddress = null,Object? contactPhone = null,Object? estimatedDaysMin = freezed,Object? estimatedDaysMax = freezed,}) {
  return _then(_CargoTariff(
destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,ratePerKg: null == ratePerKg ? _self.ratePerKg : ratePerKg // ignore: cast_nullable_to_non_nullable
as String,warehouseAddress: null == warehouseAddress ? _self.warehouseAddress : warehouseAddress // ignore: cast_nullable_to_non_nullable
as String,contactPhone: null == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String,estimatedDaysMin: freezed == estimatedDaysMin ? _self.estimatedDaysMin : estimatedDaysMin // ignore: cast_nullable_to_non_nullable
as int?,estimatedDaysMax: freezed == estimatedDaysMax ? _self.estimatedDaysMax : estimatedDaysMax // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CargoShipment {

 String get id; String get description; String get destination;@JsonKey(name: 'track_code') String? get trackCode;@JsonKey(name: 'product_link') String? get productLink;/// Zero until an operator weighs the parcel at the China warehouse —
/// which is also when [cost] stops being zero.
@JsonKey(name: 'weight_kg') double get weightKg; String get cost; CargoStatus get status; String? get note;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of CargoShipment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CargoShipmentCopyWith<CargoShipment> get copyWith => _$CargoShipmentCopyWithImpl<CargoShipment>(this as CargoShipment, _$identity);

  /// Serializes this CargoShipment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CargoShipment&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.trackCode, trackCode) || other.trackCode == trackCode)&&(identical(other.productLink, productLink) || other.productLink == productLink)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,destination,trackCode,productLink,weightKg,cost,status,note,createdAt,updatedAt);

@override
String toString() {
  return 'CargoShipment(id: $id, description: $description, destination: $destination, trackCode: $trackCode, productLink: $productLink, weightKg: $weightKg, cost: $cost, status: $status, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CargoShipmentCopyWith<$Res>  {
  factory $CargoShipmentCopyWith(CargoShipment value, $Res Function(CargoShipment) _then) = _$CargoShipmentCopyWithImpl;
@useResult
$Res call({
 String id, String description, String destination,@JsonKey(name: 'track_code') String? trackCode,@JsonKey(name: 'product_link') String? productLink,@JsonKey(name: 'weight_kg') double weightKg, String cost, CargoStatus status, String? note,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$CargoShipmentCopyWithImpl<$Res>
    implements $CargoShipmentCopyWith<$Res> {
  _$CargoShipmentCopyWithImpl(this._self, this._then);

  final CargoShipment _self;
  final $Res Function(CargoShipment) _then;

/// Create a copy of CargoShipment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? destination = null,Object? trackCode = freezed,Object? productLink = freezed,Object? weightKg = null,Object? cost = null,Object? status = null,Object? note = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(CargoShipment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,trackCode: freezed == trackCode ? _self.trackCode : trackCode // ignore: cast_nullable_to_non_nullable
as String?,productLink: freezed == productLink ? _self.productLink : productLink // ignore: cast_nullable_to_non_nullable
as String?,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CargoStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CargoShipment].
extension CargoShipmentPatterns on CargoShipment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CargoShipment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CargoShipment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CargoShipment value)  $default,){
final _that = this;
switch (_that) {
case _CargoShipment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CargoShipment value)?  $default,){
final _that = this;
switch (_that) {
case _CargoShipment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String description,  String destination, @JsonKey(name: 'track_code')  String? trackCode, @JsonKey(name: 'product_link')  String? productLink, @JsonKey(name: 'weight_kg')  double weightKg,  String cost,  CargoStatus status,  String? note, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CargoShipment() when $default != null:
return $default(_that.id,_that.description,_that.destination,_that.trackCode,_that.productLink,_that.weightKg,_that.cost,_that.status,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String description,  String destination, @JsonKey(name: 'track_code')  String? trackCode, @JsonKey(name: 'product_link')  String? productLink, @JsonKey(name: 'weight_kg')  double weightKg,  String cost,  CargoStatus status,  String? note, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CargoShipment():
return $default(_that.id,_that.description,_that.destination,_that.trackCode,_that.productLink,_that.weightKg,_that.cost,_that.status,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String description,  String destination, @JsonKey(name: 'track_code')  String? trackCode, @JsonKey(name: 'product_link')  String? productLink, @JsonKey(name: 'weight_kg')  double weightKg,  String cost,  CargoStatus status,  String? note, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CargoShipment() when $default != null:
return $default(_that.id,_that.description,_that.destination,_that.trackCode,_that.productLink,_that.weightKg,_that.cost,_that.status,_that.note,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CargoShipment extends CargoShipment {
  const _CargoShipment({required this.id, required this.description, required this.destination, @JsonKey(name: 'track_code') this.trackCode, @JsonKey(name: 'product_link') this.productLink, @JsonKey(name: 'weight_kg') this.weightKg = 0, this.cost = '0.00', this.status = CargoStatus.registered, this.note, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _CargoShipment.fromJson(Map<String, dynamic> json) => _$CargoShipmentFromJson(json);

@override final  String id;
@override final  String description;
@override final  String destination;
@override@JsonKey(name: 'track_code') final  String? trackCode;
@override@JsonKey(name: 'product_link') final  String? productLink;
/// Zero until an operator weighs the parcel at the China warehouse —
/// which is also when [cost] stops being zero.
@override@JsonKey(name: 'weight_kg') final  double weightKg;
@override@JsonKey() final  String cost;
@override@JsonKey() final  CargoStatus status;
@override final  String? note;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of CargoShipment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CargoShipmentCopyWith<_CargoShipment> get copyWith => __$CargoShipmentCopyWithImpl<_CargoShipment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CargoShipmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CargoShipment&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.trackCode, trackCode) || other.trackCode == trackCode)&&(identical(other.productLink, productLink) || other.productLink == productLink)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,destination,trackCode,productLink,weightKg,cost,status,note,createdAt,updatedAt);

@override
String toString() {
  return 'CargoShipment(id: $id, description: $description, destination: $destination, trackCode: $trackCode, productLink: $productLink, weightKg: $weightKg, cost: $cost, status: $status, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CargoShipmentCopyWith<$Res> implements $CargoShipmentCopyWith<$Res> {
  factory _$CargoShipmentCopyWith(_CargoShipment value, $Res Function(_CargoShipment) _then) = __$CargoShipmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String description, String destination,@JsonKey(name: 'track_code') String? trackCode,@JsonKey(name: 'product_link') String? productLink,@JsonKey(name: 'weight_kg') double weightKg, String cost, CargoStatus status, String? note,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$CargoShipmentCopyWithImpl<$Res>
    implements _$CargoShipmentCopyWith<$Res> {
  __$CargoShipmentCopyWithImpl(this._self, this._then);

  final _CargoShipment _self;
  final $Res Function(_CargoShipment) _then;

/// Create a copy of CargoShipment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? destination = null,Object? trackCode = freezed,Object? productLink = freezed,Object? weightKg = null,Object? cost = null,Object? status = null,Object? note = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CargoShipment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,trackCode: freezed == trackCode ? _self.trackCode : trackCode // ignore: cast_nullable_to_non_nullable
as String?,productLink: freezed == productLink ? _self.productLink : productLink // ignore: cast_nullable_to_non_nullable
as String?,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CargoStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
