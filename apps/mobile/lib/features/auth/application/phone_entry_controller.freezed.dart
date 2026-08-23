// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_entry_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhoneEntryState {

 String get rawInput; PhoneRegion get region; bool get isSubmitting; String? get normalizedPhone; AppException? get error; bool get otpSent; int get retryAfterSeconds; bool get showFormatError;/// Set once Firebase's `codeSent` callback fires — carries it forward
/// to the OTP screen so verification finishes against Firebase rather
/// than the console-OTP endpoint (docs/FIREBASE_SETUP.md).
 String? get firebaseVerificationId;/// True when Firebase auto-verified the code on-device
/// (`verificationCompleted`, Android SMS auto-retrieval) and login
/// already completed — the screen should skip the OTP screen entirely.
 bool get autoVerifiedAndLoggedIn;
/// Create a copy of PhoneEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneEntryStateCopyWith<PhoneEntryState> get copyWith => _$PhoneEntryStateCopyWithImpl<PhoneEntryState>(this as PhoneEntryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneEntryState&&(identical(other.rawInput, rawInput) || other.rawInput == rawInput)&&(identical(other.region, region) || other.region == region)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.normalizedPhone, normalizedPhone) || other.normalizedPhone == normalizedPhone)&&(identical(other.error, error) || other.error == error)&&(identical(other.otpSent, otpSent) || other.otpSent == otpSent)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds)&&(identical(other.showFormatError, showFormatError) || other.showFormatError == showFormatError)&&(identical(other.firebaseVerificationId, firebaseVerificationId) || other.firebaseVerificationId == firebaseVerificationId)&&(identical(other.autoVerifiedAndLoggedIn, autoVerifiedAndLoggedIn) || other.autoVerifiedAndLoggedIn == autoVerifiedAndLoggedIn));
}


@override
int get hashCode => Object.hash(runtimeType,rawInput,region,isSubmitting,normalizedPhone,error,otpSent,retryAfterSeconds,showFormatError,firebaseVerificationId,autoVerifiedAndLoggedIn);

@override
String toString() {
  return 'PhoneEntryState(rawInput: $rawInput, region: $region, isSubmitting: $isSubmitting, normalizedPhone: $normalizedPhone, error: $error, otpSent: $otpSent, retryAfterSeconds: $retryAfterSeconds, showFormatError: $showFormatError, firebaseVerificationId: $firebaseVerificationId, autoVerifiedAndLoggedIn: $autoVerifiedAndLoggedIn)';
}


}

/// @nodoc
abstract mixin class $PhoneEntryStateCopyWith<$Res>  {
  factory $PhoneEntryStateCopyWith(PhoneEntryState value, $Res Function(PhoneEntryState) _then) = _$PhoneEntryStateCopyWithImpl;
@useResult
$Res call({
 String rawInput, PhoneRegion region, bool isSubmitting, String? normalizedPhone, AppException? error, bool otpSent, int retryAfterSeconds, bool showFormatError, String? firebaseVerificationId, bool autoVerifiedAndLoggedIn
});




}
/// @nodoc
class _$PhoneEntryStateCopyWithImpl<$Res>
    implements $PhoneEntryStateCopyWith<$Res> {
  _$PhoneEntryStateCopyWithImpl(this._self, this._then);

  final PhoneEntryState _self;
  final $Res Function(PhoneEntryState) _then;

/// Create a copy of PhoneEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rawInput = null,Object? region = null,Object? isSubmitting = null,Object? normalizedPhone = freezed,Object? error = freezed,Object? otpSent = null,Object? retryAfterSeconds = null,Object? showFormatError = null,Object? firebaseVerificationId = freezed,Object? autoVerifiedAndLoggedIn = null,}) {
  return _then(PhoneEntryState(
rawInput: null == rawInput ? _self.rawInput : rawInput // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as PhoneRegion,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,normalizedPhone: freezed == normalizedPhone ? _self.normalizedPhone : normalizedPhone // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,otpSent: null == otpSent ? _self.otpSent : otpSent // ignore: cast_nullable_to_non_nullable
as bool,retryAfterSeconds: null == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int,showFormatError: null == showFormatError ? _self.showFormatError : showFormatError // ignore: cast_nullable_to_non_nullable
as bool,firebaseVerificationId: freezed == firebaseVerificationId ? _self.firebaseVerificationId : firebaseVerificationId // ignore: cast_nullable_to_non_nullable
as String?,autoVerifiedAndLoggedIn: null == autoVerifiedAndLoggedIn ? _self.autoVerifiedAndLoggedIn : autoVerifiedAndLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoneEntryState].
extension PhoneEntryStatePatterns on PhoneEntryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneEntryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneEntryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneEntryState value)  $default,){
final _that = this;
switch (_that) {
case _PhoneEntryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneEntryState value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneEntryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rawInput,  PhoneRegion region,  bool isSubmitting,  String? normalizedPhone,  AppException? error,  bool otpSent,  int retryAfterSeconds,  bool showFormatError,  String? firebaseVerificationId,  bool autoVerifiedAndLoggedIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneEntryState() when $default != null:
return $default(_that.rawInput,_that.region,_that.isSubmitting,_that.normalizedPhone,_that.error,_that.otpSent,_that.retryAfterSeconds,_that.showFormatError,_that.firebaseVerificationId,_that.autoVerifiedAndLoggedIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rawInput,  PhoneRegion region,  bool isSubmitting,  String? normalizedPhone,  AppException? error,  bool otpSent,  int retryAfterSeconds,  bool showFormatError,  String? firebaseVerificationId,  bool autoVerifiedAndLoggedIn)  $default,) {final _that = this;
switch (_that) {
case _PhoneEntryState():
return $default(_that.rawInput,_that.region,_that.isSubmitting,_that.normalizedPhone,_that.error,_that.otpSent,_that.retryAfterSeconds,_that.showFormatError,_that.firebaseVerificationId,_that.autoVerifiedAndLoggedIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rawInput,  PhoneRegion region,  bool isSubmitting,  String? normalizedPhone,  AppException? error,  bool otpSent,  int retryAfterSeconds,  bool showFormatError,  String? firebaseVerificationId,  bool autoVerifiedAndLoggedIn)?  $default,) {final _that = this;
switch (_that) {
case _PhoneEntryState() when $default != null:
return $default(_that.rawInput,_that.region,_that.isSubmitting,_that.normalizedPhone,_that.error,_that.otpSent,_that.retryAfterSeconds,_that.showFormatError,_that.firebaseVerificationId,_that.autoVerifiedAndLoggedIn);case _:
  return null;

}
}

}

/// @nodoc


class _PhoneEntryState extends PhoneEntryState {
  const _PhoneEntryState({this.rawInput = '', this.region = PhoneRegion.tajikistan, this.isSubmitting = false, this.normalizedPhone, this.error, this.otpSent = false, this.retryAfterSeconds = 0, this.showFormatError = false, this.firebaseVerificationId, this.autoVerifiedAndLoggedIn = false}): super._();
  

@override@JsonKey() final  String rawInput;
@override@JsonKey() final  PhoneRegion region;
@override@JsonKey() final  bool isSubmitting;
@override final  String? normalizedPhone;
@override final  AppException? error;
@override@JsonKey() final  bool otpSent;
@override@JsonKey() final  int retryAfterSeconds;
@override@JsonKey() final  bool showFormatError;
/// Set once Firebase's `codeSent` callback fires — carries it forward
/// to the OTP screen so verification finishes against Firebase rather
/// than the console-OTP endpoint (docs/FIREBASE_SETUP.md).
@override final  String? firebaseVerificationId;
/// True when Firebase auto-verified the code on-device
/// (`verificationCompleted`, Android SMS auto-retrieval) and login
/// already completed — the screen should skip the OTP screen entirely.
@override@JsonKey() final  bool autoVerifiedAndLoggedIn;

/// Create a copy of PhoneEntryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneEntryStateCopyWith<_PhoneEntryState> get copyWith => __$PhoneEntryStateCopyWithImpl<_PhoneEntryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneEntryState&&(identical(other.rawInput, rawInput) || other.rawInput == rawInput)&&(identical(other.region, region) || other.region == region)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.normalizedPhone, normalizedPhone) || other.normalizedPhone == normalizedPhone)&&(identical(other.error, error) || other.error == error)&&(identical(other.otpSent, otpSent) || other.otpSent == otpSent)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds)&&(identical(other.showFormatError, showFormatError) || other.showFormatError == showFormatError)&&(identical(other.firebaseVerificationId, firebaseVerificationId) || other.firebaseVerificationId == firebaseVerificationId)&&(identical(other.autoVerifiedAndLoggedIn, autoVerifiedAndLoggedIn) || other.autoVerifiedAndLoggedIn == autoVerifiedAndLoggedIn));
}


@override
int get hashCode => Object.hash(runtimeType,rawInput,region,isSubmitting,normalizedPhone,error,otpSent,retryAfterSeconds,showFormatError,firebaseVerificationId,autoVerifiedAndLoggedIn);

@override
String toString() {
  return 'PhoneEntryState(rawInput: $rawInput, region: $region, isSubmitting: $isSubmitting, normalizedPhone: $normalizedPhone, error: $error, otpSent: $otpSent, retryAfterSeconds: $retryAfterSeconds, showFormatError: $showFormatError, firebaseVerificationId: $firebaseVerificationId, autoVerifiedAndLoggedIn: $autoVerifiedAndLoggedIn)';
}


}

/// @nodoc
abstract mixin class _$PhoneEntryStateCopyWith<$Res> implements $PhoneEntryStateCopyWith<$Res> {
  factory _$PhoneEntryStateCopyWith(_PhoneEntryState value, $Res Function(_PhoneEntryState) _then) = __$PhoneEntryStateCopyWithImpl;
@override @useResult
$Res call({
 String rawInput, PhoneRegion region, bool isSubmitting, String? normalizedPhone, AppException? error, bool otpSent, int retryAfterSeconds, bool showFormatError, String? firebaseVerificationId, bool autoVerifiedAndLoggedIn
});




}
/// @nodoc
class __$PhoneEntryStateCopyWithImpl<$Res>
    implements _$PhoneEntryStateCopyWith<$Res> {
  __$PhoneEntryStateCopyWithImpl(this._self, this._then);

  final _PhoneEntryState _self;
  final $Res Function(_PhoneEntryState) _then;

/// Create a copy of PhoneEntryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rawInput = null,Object? region = null,Object? isSubmitting = null,Object? normalizedPhone = freezed,Object? error = freezed,Object? otpSent = null,Object? retryAfterSeconds = null,Object? showFormatError = null,Object? firebaseVerificationId = freezed,Object? autoVerifiedAndLoggedIn = null,}) {
  return _then(_PhoneEntryState(
rawInput: null == rawInput ? _self.rawInput : rawInput // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as PhoneRegion,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,normalizedPhone: freezed == normalizedPhone ? _self.normalizedPhone : normalizedPhone // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,otpSent: null == otpSent ? _self.otpSent : otpSent // ignore: cast_nullable_to_non_nullable
as bool,retryAfterSeconds: null == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int,showFormatError: null == showFormatError ? _self.showFormatError : showFormatError // ignore: cast_nullable_to_non_nullable
as bool,firebaseVerificationId: freezed == firebaseVerificationId ? _self.firebaseVerificationId : firebaseVerificationId // ignore: cast_nullable_to_non_nullable
as String?,autoVerifiedAndLoggedIn: null == autoVerifiedAndLoggedIn ? _self.autoVerifiedAndLoggedIn : autoVerifiedAndLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
