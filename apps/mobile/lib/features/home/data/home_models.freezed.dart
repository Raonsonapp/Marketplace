// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeFeed {

 List<BannerItem>? get banners; List<Category>? get categories; List<Product>? get popular; List<Product>? get discounted; List<Product>? get recommended; List<Product>? get recentlyViewed; List<Product>? get personalOffers; List<Store>? get nearbyStores; List<Brand>? get featuredBrands; List<Product>? get buyAgain;
/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeFeedCopyWith<HomeFeed> get copyWith => _$HomeFeedCopyWithImpl<HomeFeed>(this as HomeFeed, _$identity);

  /// Serializes this HomeFeed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeFeed&&const DeepCollectionEquality().equals(other.banners, banners)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.popular, popular)&&const DeepCollectionEquality().equals(other.discounted, discounted)&&const DeepCollectionEquality().equals(other.recommended, recommended)&&const DeepCollectionEquality().equals(other.recentlyViewed, recentlyViewed)&&const DeepCollectionEquality().equals(other.personalOffers, personalOffers)&&const DeepCollectionEquality().equals(other.nearbyStores, nearbyStores)&&const DeepCollectionEquality().equals(other.featuredBrands, featuredBrands)&&const DeepCollectionEquality().equals(other.buyAgain, buyAgain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(banners),const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(popular),const DeepCollectionEquality().hash(discounted),const DeepCollectionEquality().hash(recommended),const DeepCollectionEquality().hash(recentlyViewed),const DeepCollectionEquality().hash(personalOffers),const DeepCollectionEquality().hash(nearbyStores),const DeepCollectionEquality().hash(featuredBrands),const DeepCollectionEquality().hash(buyAgain));

@override
String toString() {
  return 'HomeFeed(banners: $banners, categories: $categories, popular: $popular, discounted: $discounted, recommended: $recommended, recentlyViewed: $recentlyViewed, personalOffers: $personalOffers, nearbyStores: $nearbyStores, featuredBrands: $featuredBrands, buyAgain: $buyAgain)';
}


}

/// @nodoc
abstract mixin class $HomeFeedCopyWith<$Res>  {
  factory $HomeFeedCopyWith(HomeFeed value, $Res Function(HomeFeed) _then) = _$HomeFeedCopyWithImpl;
@useResult
$Res call({
 List<BannerItem>? banners, List<Category>? categories, List<Product>? popular, List<Product>? discounted, List<Product>? recommended, List<Product>? recentlyViewed, List<Product>? personalOffers, List<Store>? nearbyStores, List<Brand>? featuredBrands, List<Product>? buyAgain
});




}
/// @nodoc
class _$HomeFeedCopyWithImpl<$Res>
    implements $HomeFeedCopyWith<$Res> {
  _$HomeFeedCopyWithImpl(this._self, this._then);

  final HomeFeed _self;
  final $Res Function(HomeFeed) _then;

/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? banners = freezed,Object? categories = freezed,Object? popular = freezed,Object? discounted = freezed,Object? recommended = freezed,Object? recentlyViewed = freezed,Object? personalOffers = freezed,Object? nearbyStores = freezed,Object? featuredBrands = freezed,Object? buyAgain = freezed,}) {
  return _then(HomeFeed(
banners: freezed == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerItem>?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>?,popular: freezed == popular ? _self.popular : popular // ignore: cast_nullable_to_non_nullable
as List<Product>?,discounted: freezed == discounted ? _self.discounted : discounted // ignore: cast_nullable_to_non_nullable
as List<Product>?,recommended: freezed == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as List<Product>?,recentlyViewed: freezed == recentlyViewed ? _self.recentlyViewed : recentlyViewed // ignore: cast_nullable_to_non_nullable
as List<Product>?,personalOffers: freezed == personalOffers ? _self.personalOffers : personalOffers // ignore: cast_nullable_to_non_nullable
as List<Product>?,nearbyStores: freezed == nearbyStores ? _self.nearbyStores : nearbyStores // ignore: cast_nullable_to_non_nullable
as List<Store>?,featuredBrands: freezed == featuredBrands ? _self.featuredBrands : featuredBrands // ignore: cast_nullable_to_non_nullable
as List<Brand>?,buyAgain: freezed == buyAgain ? _self.buyAgain : buyAgain // ignore: cast_nullable_to_non_nullable
as List<Product>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeFeed].
extension HomeFeedPatterns on HomeFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeFeed value)  $default,){
final _that = this;
switch (_that) {
case _HomeFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeFeed value)?  $default,){
final _that = this;
switch (_that) {
case _HomeFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BannerItem>? banners,  List<Category>? categories,  List<Product>? popular,  List<Product>? discounted,  List<Product>? recommended,  List<Product>? recentlyViewed,  List<Product>? personalOffers,  List<Store>? nearbyStores,  List<Brand>? featuredBrands,  List<Product>? buyAgain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeFeed() when $default != null:
return $default(_that.banners,_that.categories,_that.popular,_that.discounted,_that.recommended,_that.recentlyViewed,_that.personalOffers,_that.nearbyStores,_that.featuredBrands,_that.buyAgain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BannerItem>? banners,  List<Category>? categories,  List<Product>? popular,  List<Product>? discounted,  List<Product>? recommended,  List<Product>? recentlyViewed,  List<Product>? personalOffers,  List<Store>? nearbyStores,  List<Brand>? featuredBrands,  List<Product>? buyAgain)  $default,) {final _that = this;
switch (_that) {
case _HomeFeed():
return $default(_that.banners,_that.categories,_that.popular,_that.discounted,_that.recommended,_that.recentlyViewed,_that.personalOffers,_that.nearbyStores,_that.featuredBrands,_that.buyAgain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BannerItem>? banners,  List<Category>? categories,  List<Product>? popular,  List<Product>? discounted,  List<Product>? recommended,  List<Product>? recentlyViewed,  List<Product>? personalOffers,  List<Store>? nearbyStores,  List<Brand>? featuredBrands,  List<Product>? buyAgain)?  $default,) {final _that = this;
switch (_that) {
case _HomeFeed() when $default != null:
return $default(_that.banners,_that.categories,_that.popular,_that.discounted,_that.recommended,_that.recentlyViewed,_that.personalOffers,_that.nearbyStores,_that.featuredBrands,_that.buyAgain);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeFeed extends HomeFeed {
  const _HomeFeed({ List<BannerItem>? banners,  List<Category>? categories,  List<Product>? popular,  List<Product>? discounted,  List<Product>? recommended,  List<Product>? recentlyViewed,  List<Product>? personalOffers,  List<Store>? nearbyStores,  List<Brand>? featuredBrands,  List<Product>? buyAgain}): _banners = banners,_categories = categories,_popular = popular,_discounted = discounted,_recommended = recommended,_recentlyViewed = recentlyViewed,_personalOffers = personalOffers,_nearbyStores = nearbyStores,_featuredBrands = featuredBrands,_buyAgain = buyAgain,super._();
  factory _HomeFeed.fromJson(Map<String, dynamic> json) => _$HomeFeedFromJson(json);

 final  List<BannerItem>? _banners;
@override List<BannerItem>? get banners {
  final value = _banners;
  if (value == null) return null;
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Category>? _categories;
@override List<Category>? get categories {
  final value = _categories;
  if (value == null) return null;
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Product>? _popular;
@override List<Product>? get popular {
  final value = _popular;
  if (value == null) return null;
  if (_popular is EqualUnmodifiableListView) return _popular;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Product>? _discounted;
@override List<Product>? get discounted {
  final value = _discounted;
  if (value == null) return null;
  if (_discounted is EqualUnmodifiableListView) return _discounted;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Product>? _recommended;
@override List<Product>? get recommended {
  final value = _recommended;
  if (value == null) return null;
  if (_recommended is EqualUnmodifiableListView) return _recommended;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Product>? _recentlyViewed;
@override List<Product>? get recentlyViewed {
  final value = _recentlyViewed;
  if (value == null) return null;
  if (_recentlyViewed is EqualUnmodifiableListView) return _recentlyViewed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Product>? _personalOffers;
@override List<Product>? get personalOffers {
  final value = _personalOffers;
  if (value == null) return null;
  if (_personalOffers is EqualUnmodifiableListView) return _personalOffers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Store>? _nearbyStores;
@override List<Store>? get nearbyStores {
  final value = _nearbyStores;
  if (value == null) return null;
  if (_nearbyStores is EqualUnmodifiableListView) return _nearbyStores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Brand>? _featuredBrands;
@override List<Brand>? get featuredBrands {
  final value = _featuredBrands;
  if (value == null) return null;
  if (_featuredBrands is EqualUnmodifiableListView) return _featuredBrands;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Product>? _buyAgain;
@override List<Product>? get buyAgain {
  final value = _buyAgain;
  if (value == null) return null;
  if (_buyAgain is EqualUnmodifiableListView) return _buyAgain;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeFeedCopyWith<_HomeFeed> get copyWith => __$HomeFeedCopyWithImpl<_HomeFeed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeFeedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeFeed&&const DeepCollectionEquality().equals(other._banners, _banners)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._popular, _popular)&&const DeepCollectionEquality().equals(other._discounted, _discounted)&&const DeepCollectionEquality().equals(other._recommended, _recommended)&&const DeepCollectionEquality().equals(other._recentlyViewed, _recentlyViewed)&&const DeepCollectionEquality().equals(other._personalOffers, _personalOffers)&&const DeepCollectionEquality().equals(other._nearbyStores, _nearbyStores)&&const DeepCollectionEquality().equals(other._featuredBrands, _featuredBrands)&&const DeepCollectionEquality().equals(other._buyAgain, _buyAgain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_banners),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_popular),const DeepCollectionEquality().hash(_discounted),const DeepCollectionEquality().hash(_recommended),const DeepCollectionEquality().hash(_recentlyViewed),const DeepCollectionEquality().hash(_personalOffers),const DeepCollectionEquality().hash(_nearbyStores),const DeepCollectionEquality().hash(_featuredBrands),const DeepCollectionEquality().hash(_buyAgain));

@override
String toString() {
  return 'HomeFeed(banners: $banners, categories: $categories, popular: $popular, discounted: $discounted, recommended: $recommended, recentlyViewed: $recentlyViewed, personalOffers: $personalOffers, nearbyStores: $nearbyStores, featuredBrands: $featuredBrands, buyAgain: $buyAgain)';
}


}

/// @nodoc
abstract mixin class _$HomeFeedCopyWith<$Res> implements $HomeFeedCopyWith<$Res> {
  factory _$HomeFeedCopyWith(_HomeFeed value, $Res Function(_HomeFeed) _then) = __$HomeFeedCopyWithImpl;
@override @useResult
$Res call({
 List<BannerItem>? banners, List<Category>? categories, List<Product>? popular, List<Product>? discounted, List<Product>? recommended, List<Product>? recentlyViewed, List<Product>? personalOffers, List<Store>? nearbyStores, List<Brand>? featuredBrands, List<Product>? buyAgain
});




}
/// @nodoc
class __$HomeFeedCopyWithImpl<$Res>
    implements _$HomeFeedCopyWith<$Res> {
  __$HomeFeedCopyWithImpl(this._self, this._then);

  final _HomeFeed _self;
  final $Res Function(_HomeFeed) _then;

/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? banners = freezed,Object? categories = freezed,Object? popular = freezed,Object? discounted = freezed,Object? recommended = freezed,Object? recentlyViewed = freezed,Object? personalOffers = freezed,Object? nearbyStores = freezed,Object? featuredBrands = freezed,Object? buyAgain = freezed,}) {
  return _then(_HomeFeed(
banners: freezed == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerItem>?,categories: freezed == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>?,popular: freezed == popular ? _self._popular : popular // ignore: cast_nullable_to_non_nullable
as List<Product>?,discounted: freezed == discounted ? _self._discounted : discounted // ignore: cast_nullable_to_non_nullable
as List<Product>?,recommended: freezed == recommended ? _self._recommended : recommended // ignore: cast_nullable_to_non_nullable
as List<Product>?,recentlyViewed: freezed == recentlyViewed ? _self._recentlyViewed : recentlyViewed // ignore: cast_nullable_to_non_nullable
as List<Product>?,personalOffers: freezed == personalOffers ? _self._personalOffers : personalOffers // ignore: cast_nullable_to_non_nullable
as List<Product>?,nearbyStores: freezed == nearbyStores ? _self._nearbyStores : nearbyStores // ignore: cast_nullable_to_non_nullable
as List<Store>?,featuredBrands: freezed == featuredBrands ? _self._featuredBrands : featuredBrands // ignore: cast_nullable_to_non_nullable
as List<Brand>?,buyAgain: freezed == buyAgain ? _self._buyAgain : buyAgain // ignore: cast_nullable_to_non_nullable
as List<Product>?,
  ));
}


}

// dart format on
