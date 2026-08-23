// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchScreenState {

 String get query; bool get isSearching; bool get isLoadingSuggestions; PaginatedState<Product>? get results; SearchSuggestions get suggestions; List<String> get recentSearches; AppException? get error;
/// Create a copy of SearchScreenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchScreenStateCopyWith<SearchScreenState> get copyWith => _$SearchScreenStateCopyWithImpl<SearchScreenState>(this as SearchScreenState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchScreenState&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingSuggestions, isLoadingSuggestions) || other.isLoadingSuggestions == isLoadingSuggestions)&&(identical(other.results, results) || other.results == results)&&(identical(other.suggestions, suggestions) || other.suggestions == suggestions)&&const DeepCollectionEquality().equals(other.recentSearches, recentSearches)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,query,isSearching,isLoadingSuggestions,results,suggestions,const DeepCollectionEquality().hash(recentSearches),error);

@override
String toString() {
  return 'SearchScreenState(query: $query, isSearching: $isSearching, isLoadingSuggestions: $isLoadingSuggestions, results: $results, suggestions: $suggestions, recentSearches: $recentSearches, error: $error)';
}


}

/// @nodoc
abstract mixin class $SearchScreenStateCopyWith<$Res>  {
  factory $SearchScreenStateCopyWith(SearchScreenState value, $Res Function(SearchScreenState) _then) = _$SearchScreenStateCopyWithImpl;
@useResult
$Res call({
 String query, bool isSearching, bool isLoadingSuggestions, PaginatedState<Product>? results, SearchSuggestions suggestions, List<String> recentSearches, AppException? error
});


$SearchSuggestionsCopyWith<$Res> get suggestions;

}
/// @nodoc
class _$SearchScreenStateCopyWithImpl<$Res>
    implements $SearchScreenStateCopyWith<$Res> {
  _$SearchScreenStateCopyWithImpl(this._self, this._then);

  final SearchScreenState _self;
  final $Res Function(SearchScreenState) _then;

/// Create a copy of SearchScreenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? isSearching = null,Object? isLoadingSuggestions = null,Object? results = freezed,Object? suggestions = null,Object? recentSearches = null,Object? error = freezed,}) {
  return _then(SearchScreenState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingSuggestions: null == isLoadingSuggestions ? _self.isLoadingSuggestions : isLoadingSuggestions // ignore: cast_nullable_to_non_nullable
as bool,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as PaginatedState<Product>?,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as SearchSuggestions,recentSearches: null == recentSearches ? _self.recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as List<String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}
/// Create a copy of SearchScreenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchSuggestionsCopyWith<$Res> get suggestions {
  
  return $SearchSuggestionsCopyWith<$Res>(_self.suggestions, (value) {
    return _then(_self.copyWith(suggestions: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchScreenState].
extension SearchScreenStatePatterns on SearchScreenState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchScreenState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchScreenState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchScreenState value)  $default,){
final _that = this;
switch (_that) {
case _SearchScreenState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchScreenState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchScreenState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  bool isSearching,  bool isLoadingSuggestions,  PaginatedState<Product>? results,  SearchSuggestions suggestions,  List<String> recentSearches,  AppException? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchScreenState() when $default != null:
return $default(_that.query,_that.isSearching,_that.isLoadingSuggestions,_that.results,_that.suggestions,_that.recentSearches,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  bool isSearching,  bool isLoadingSuggestions,  PaginatedState<Product>? results,  SearchSuggestions suggestions,  List<String> recentSearches,  AppException? error)  $default,) {final _that = this;
switch (_that) {
case _SearchScreenState():
return $default(_that.query,_that.isSearching,_that.isLoadingSuggestions,_that.results,_that.suggestions,_that.recentSearches,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  bool isSearching,  bool isLoadingSuggestions,  PaginatedState<Product>? results,  SearchSuggestions suggestions,  List<String> recentSearches,  AppException? error)?  $default,) {final _that = this;
switch (_that) {
case _SearchScreenState() when $default != null:
return $default(_that.query,_that.isSearching,_that.isLoadingSuggestions,_that.results,_that.suggestions,_that.recentSearches,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SearchScreenState implements SearchScreenState {
  const _SearchScreenState({this.query = '', this.isSearching = false, this.isLoadingSuggestions = false, this.results, this.suggestions = const SearchSuggestions(),  List<String> recentSearches = const <String>[], this.error}): _recentSearches = recentSearches;
  

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isSearching;
@override@JsonKey() final  bool isLoadingSuggestions;
@override final  PaginatedState<Product>? results;
@override@JsonKey() final  SearchSuggestions suggestions;
 final  List<String> _recentSearches;
@override@JsonKey() List<String> get recentSearches {
  if (_recentSearches is EqualUnmodifiableListView) return _recentSearches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentSearches);
}

@override final  AppException? error;

/// Create a copy of SearchScreenState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchScreenStateCopyWith<_SearchScreenState> get copyWith => __$SearchScreenStateCopyWithImpl<_SearchScreenState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchScreenState&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingSuggestions, isLoadingSuggestions) || other.isLoadingSuggestions == isLoadingSuggestions)&&(identical(other.results, results) || other.results == results)&&(identical(other.suggestions, suggestions) || other.suggestions == suggestions)&&const DeepCollectionEquality().equals(other._recentSearches, _recentSearches)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,query,isSearching,isLoadingSuggestions,results,suggestions,const DeepCollectionEquality().hash(_recentSearches),error);

@override
String toString() {
  return 'SearchScreenState(query: $query, isSearching: $isSearching, isLoadingSuggestions: $isLoadingSuggestions, results: $results, suggestions: $suggestions, recentSearches: $recentSearches, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SearchScreenStateCopyWith<$Res> implements $SearchScreenStateCopyWith<$Res> {
  factory _$SearchScreenStateCopyWith(_SearchScreenState value, $Res Function(_SearchScreenState) _then) = __$SearchScreenStateCopyWithImpl;
@override @useResult
$Res call({
 String query, bool isSearching, bool isLoadingSuggestions, PaginatedState<Product>? results, SearchSuggestions suggestions, List<String> recentSearches, AppException? error
});


@override $SearchSuggestionsCopyWith<$Res> get suggestions;

}
/// @nodoc
class __$SearchScreenStateCopyWithImpl<$Res>
    implements _$SearchScreenStateCopyWith<$Res> {
  __$SearchScreenStateCopyWithImpl(this._self, this._then);

  final _SearchScreenState _self;
  final $Res Function(_SearchScreenState) _then;

/// Create a copy of SearchScreenState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? isSearching = null,Object? isLoadingSuggestions = null,Object? results = freezed,Object? suggestions = null,Object? recentSearches = null,Object? error = freezed,}) {
  return _then(_SearchScreenState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingSuggestions: null == isLoadingSuggestions ? _self.isLoadingSuggestions : isLoadingSuggestions // ignore: cast_nullable_to_non_nullable
as bool,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as PaginatedState<Product>?,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as SearchSuggestions,recentSearches: null == recentSearches ? _self._recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as List<String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}

/// Create a copy of SearchScreenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchSuggestionsCopyWith<$Res> get suggestions {
  
  return $SearchSuggestionsCopyWith<$Res>(_self.suggestions, (value) {
    return _then(_self.copyWith(suggestions: value));
  });
}
}

// dart format on
