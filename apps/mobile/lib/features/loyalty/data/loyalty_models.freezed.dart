// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoyaltyAccount {

 String get balance; String get tier; String get lifetimeEarned;
/// Create a copy of LoyaltyAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyAccountCopyWith<LoyaltyAccount> get copyWith => _$LoyaltyAccountCopyWithImpl<LoyaltyAccount>(this as LoyaltyAccount, _$identity);

  /// Serializes this LoyaltyAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyAccount&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.lifetimeEarned, lifetimeEarned) || other.lifetimeEarned == lifetimeEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,tier,lifetimeEarned);

@override
String toString() {
  return 'LoyaltyAccount(balance: $balance, tier: $tier, lifetimeEarned: $lifetimeEarned)';
}


}

/// @nodoc
abstract mixin class $LoyaltyAccountCopyWith<$Res>  {
  factory $LoyaltyAccountCopyWith(LoyaltyAccount value, $Res Function(LoyaltyAccount) _then) = _$LoyaltyAccountCopyWithImpl;
@useResult
$Res call({
 String balance, String tier, String lifetimeEarned
});




}
/// @nodoc
class _$LoyaltyAccountCopyWithImpl<$Res>
    implements $LoyaltyAccountCopyWith<$Res> {
  _$LoyaltyAccountCopyWithImpl(this._self, this._then);

  final LoyaltyAccount _self;
  final $Res Function(LoyaltyAccount) _then;

/// Create a copy of LoyaltyAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,Object? tier = null,Object? lifetimeEarned = null,}) {
  return _then(LoyaltyAccount(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,lifetimeEarned: null == lifetimeEarned ? _self.lifetimeEarned : lifetimeEarned // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyAccount].
extension LoyaltyAccountPatterns on LoyaltyAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyAccount value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyAccount value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String balance,  String tier,  String lifetimeEarned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoyaltyAccount() when $default != null:
return $default(_that.balance,_that.tier,_that.lifetimeEarned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String balance,  String tier,  String lifetimeEarned)  $default,) {final _that = this;
switch (_that) {
case _LoyaltyAccount():
return $default(_that.balance,_that.tier,_that.lifetimeEarned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String balance,  String tier,  String lifetimeEarned)?  $default,) {final _that = this;
switch (_that) {
case _LoyaltyAccount() when $default != null:
return $default(_that.balance,_that.tier,_that.lifetimeEarned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoyaltyAccount implements LoyaltyAccount {
  const _LoyaltyAccount({required this.balance, required this.tier, required this.lifetimeEarned});
  factory _LoyaltyAccount.fromJson(Map<String, dynamic> json) => _$LoyaltyAccountFromJson(json);

@override final  String balance;
@override final  String tier;
@override final  String lifetimeEarned;

/// Create a copy of LoyaltyAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyAccountCopyWith<_LoyaltyAccount> get copyWith => __$LoyaltyAccountCopyWithImpl<_LoyaltyAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoyaltyAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyAccount&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.lifetimeEarned, lifetimeEarned) || other.lifetimeEarned == lifetimeEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,tier,lifetimeEarned);

@override
String toString() {
  return 'LoyaltyAccount(balance: $balance, tier: $tier, lifetimeEarned: $lifetimeEarned)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyAccountCopyWith<$Res> implements $LoyaltyAccountCopyWith<$Res> {
  factory _$LoyaltyAccountCopyWith(_LoyaltyAccount value, $Res Function(_LoyaltyAccount) _then) = __$LoyaltyAccountCopyWithImpl;
@override @useResult
$Res call({
 String balance, String tier, String lifetimeEarned
});




}
/// @nodoc
class __$LoyaltyAccountCopyWithImpl<$Res>
    implements _$LoyaltyAccountCopyWith<$Res> {
  __$LoyaltyAccountCopyWithImpl(this._self, this._then);

  final _LoyaltyAccount _self;
  final $Res Function(_LoyaltyAccount) _then;

/// Create a copy of LoyaltyAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? tier = null,Object? lifetimeEarned = null,}) {
  return _then(_LoyaltyAccount(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,lifetimeEarned: null == lifetimeEarned ? _self.lifetimeEarned : lifetimeEarned // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LoyaltyTransaction {

 String get id; String get type; String get amount; String get balanceAfter; String? get description; DateTime get createdAt; DateTime? get expiresAt;
/// Create a copy of LoyaltyTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyTransactionCopyWith<LoyaltyTransaction> get copyWith => _$LoyaltyTransactionCopyWithImpl<LoyaltyTransaction>(this as LoyaltyTransaction, _$identity);

  /// Serializes this LoyaltyTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,balanceAfter,description,createdAt,expiresAt);

@override
String toString() {
  return 'LoyaltyTransaction(id: $id, type: $type, amount: $amount, balanceAfter: $balanceAfter, description: $description, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $LoyaltyTransactionCopyWith<$Res>  {
  factory $LoyaltyTransactionCopyWith(LoyaltyTransaction value, $Res Function(LoyaltyTransaction) _then) = _$LoyaltyTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String type, String amount, String balanceAfter, String? description, DateTime createdAt, DateTime? expiresAt
});




}
/// @nodoc
class _$LoyaltyTransactionCopyWithImpl<$Res>
    implements $LoyaltyTransactionCopyWith<$Res> {
  _$LoyaltyTransactionCopyWithImpl(this._self, this._then);

  final LoyaltyTransaction _self;
  final $Res Function(LoyaltyTransaction) _then;

/// Create a copy of LoyaltyTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? balanceAfter = null,Object? description = freezed,Object? createdAt = null,Object? expiresAt = freezed,}) {
  return _then(LoyaltyTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,balanceAfter: null == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyTransaction].
extension LoyaltyTransactionPatterns on LoyaltyTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyTransaction value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String amount,  String balanceAfter,  String? description,  DateTime createdAt,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoyaltyTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.balanceAfter,_that.description,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String amount,  String balanceAfter,  String? description,  DateTime createdAt,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _LoyaltyTransaction():
return $default(_that.id,_that.type,_that.amount,_that.balanceAfter,_that.description,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String amount,  String balanceAfter,  String? description,  DateTime createdAt,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _LoyaltyTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.balanceAfter,_that.description,_that.createdAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoyaltyTransaction implements LoyaltyTransaction {
  const _LoyaltyTransaction({required this.id, required this.type, required this.amount, required this.balanceAfter, this.description, required this.createdAt, this.expiresAt});
  factory _LoyaltyTransaction.fromJson(Map<String, dynamic> json) => _$LoyaltyTransactionFromJson(json);

@override final  String id;
@override final  String type;
@override final  String amount;
@override final  String balanceAfter;
@override final  String? description;
@override final  DateTime createdAt;
@override final  DateTime? expiresAt;

/// Create a copy of LoyaltyTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyTransactionCopyWith<_LoyaltyTransaction> get copyWith => __$LoyaltyTransactionCopyWithImpl<_LoyaltyTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoyaltyTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,balanceAfter,description,createdAt,expiresAt);

@override
String toString() {
  return 'LoyaltyTransaction(id: $id, type: $type, amount: $amount, balanceAfter: $balanceAfter, description: $description, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyTransactionCopyWith<$Res> implements $LoyaltyTransactionCopyWith<$Res> {
  factory _$LoyaltyTransactionCopyWith(_LoyaltyTransaction value, $Res Function(_LoyaltyTransaction) _then) = __$LoyaltyTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String amount, String balanceAfter, String? description, DateTime createdAt, DateTime? expiresAt
});




}
/// @nodoc
class __$LoyaltyTransactionCopyWithImpl<$Res>
    implements _$LoyaltyTransactionCopyWith<$Res> {
  __$LoyaltyTransactionCopyWithImpl(this._self, this._then);

  final _LoyaltyTransaction _self;
  final $Res Function(_LoyaltyTransaction) _then;

/// Create a copy of LoyaltyTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? balanceAfter = null,Object? description = freezed,Object? createdAt = null,Object? expiresAt = freezed,}) {
  return _then(_LoyaltyTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,balanceAfter: null == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
