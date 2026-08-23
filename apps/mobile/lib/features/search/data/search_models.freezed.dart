// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchSuggestions {

 List<String> get suggestions; List<String> get popular;
/// Create a copy of SearchSuggestions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchSuggestionsCopyWith<SearchSuggestions> get copyWith => _$SearchSuggestionsCopyWithImpl<SearchSuggestions>(this as SearchSuggestions, _$identity);

  /// Serializes this SearchSuggestions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSuggestions&&const DeepCollectionEquality().equals(other.suggestions, suggestions)&&const DeepCollectionEquality().equals(other.popular, popular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(suggestions),const DeepCollectionEquality().hash(popular));

@override
String toString() {
  return 'SearchSuggestions(suggestions: $suggestions, popular: $popular)';
}


}

/// @nodoc
abstract mixin class $SearchSuggestionsCopyWith<$Res>  {
  factory $SearchSuggestionsCopyWith(SearchSuggestions value, $Res Function(SearchSuggestions) _then) = _$SearchSuggestionsCopyWithImpl;
@useResult
$Res call({
 List<String> suggestions, List<String> popular
});




}
/// @nodoc
class _$SearchSuggestionsCopyWithImpl<$Res>
    implements $SearchSuggestionsCopyWith<$Res> {
  _$SearchSuggestionsCopyWithImpl(this._self, this._then);

  final SearchSuggestions _self;
  final $Res Function(SearchSuggestions) _then;

/// Create a copy of SearchSuggestions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suggestions = null,Object? popular = null,}) {
  return _then(SearchSuggestions(
suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,popular: null == popular ? _self.popular : popular // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchSuggestions].
extension SearchSuggestionsPatterns on SearchSuggestions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchSuggestions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchSuggestions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchSuggestions value)  $default,){
final _that = this;
switch (_that) {
case _SearchSuggestions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchSuggestions value)?  $default,){
final _that = this;
switch (_that) {
case _SearchSuggestions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> suggestions,  List<String> popular)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchSuggestions() when $default != null:
return $default(_that.suggestions,_that.popular);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> suggestions,  List<String> popular)  $default,) {final _that = this;
switch (_that) {
case _SearchSuggestions():
return $default(_that.suggestions,_that.popular);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> suggestions,  List<String> popular)?  $default,) {final _that = this;
switch (_that) {
case _SearchSuggestions() when $default != null:
return $default(_that.suggestions,_that.popular);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchSuggestions implements SearchSuggestions {
  const _SearchSuggestions({ List<String> suggestions = const <String>[],  List<String> popular = const <String>[]}): _suggestions = suggestions,_popular = popular;
  factory _SearchSuggestions.fromJson(Map<String, dynamic> json) => _$SearchSuggestionsFromJson(json);

 final  List<String> _suggestions;
@override@JsonKey() List<String> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}

 final  List<String> _popular;
@override@JsonKey() List<String> get popular {
  if (_popular is EqualUnmodifiableListView) return _popular;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_popular);
}


/// Create a copy of SearchSuggestions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchSuggestionsCopyWith<_SearchSuggestions> get copyWith => __$SearchSuggestionsCopyWithImpl<_SearchSuggestions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchSuggestionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchSuggestions&&const DeepCollectionEquality().equals(other._suggestions, _suggestions)&&const DeepCollectionEquality().equals(other._popular, _popular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_suggestions),const DeepCollectionEquality().hash(_popular));

@override
String toString() {
  return 'SearchSuggestions(suggestions: $suggestions, popular: $popular)';
}


}

/// @nodoc
abstract mixin class _$SearchSuggestionsCopyWith<$Res> implements $SearchSuggestionsCopyWith<$Res> {
  factory _$SearchSuggestionsCopyWith(_SearchSuggestions value, $Res Function(_SearchSuggestions) _then) = __$SearchSuggestionsCopyWithImpl;
@override @useResult
$Res call({
 List<String> suggestions, List<String> popular
});




}
/// @nodoc
class __$SearchSuggestionsCopyWithImpl<$Res>
    implements _$SearchSuggestionsCopyWith<$Res> {
  __$SearchSuggestionsCopyWithImpl(this._self, this._then);

  final _SearchSuggestions _self;
  final $Res Function(_SearchSuggestions) _then;

/// Create a copy of SearchSuggestions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suggestions = null,Object? popular = null,}) {
  return _then(_SearchSuggestions(
suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,popular: null == popular ? _self._popular : popular // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
