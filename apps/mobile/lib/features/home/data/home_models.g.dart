// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeFeed _$HomeFeedFromJson(Map<String, dynamic> json) => _HomeFeed(
  banners: (json['banners'] as List<dynamic>?)
      ?.map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
      .toList(),
  popular: (json['popular'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
  discounted: (json['discounted'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
  recommended: (json['recommended'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentlyViewed: (json['recently_viewed'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
  personalOffers: (json['personal_offers'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
  nearbyStores: (json['nearby_stores'] as List<dynamic>?)
      ?.map((e) => Store.fromJson(e as Map<String, dynamic>))
      .toList(),
  featuredBrands: (json['featured_brands'] as List<dynamic>?)
      ?.map((e) => Brand.fromJson(e as Map<String, dynamic>))
      .toList(),
  buyAgain: (json['buy_again'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HomeFeedToJson(_HomeFeed instance) => <String, dynamic>{
  'banners': ?instance.banners?.map((e) => e.toJson()).toList(),
  'categories': ?instance.categories?.map((e) => e.toJson()).toList(),
  'popular': ?instance.popular?.map((e) => e.toJson()).toList(),
  'discounted': ?instance.discounted?.map((e) => e.toJson()).toList(),
  'recommended': ?instance.recommended?.map((e) => e.toJson()).toList(),
  'recently_viewed': ?instance.recentlyViewed?.map((e) => e.toJson()).toList(),
  'personal_offers': ?instance.personalOffers?.map((e) => e.toJson()).toList(),
  'nearby_stores': ?instance.nearbyStores?.map((e) => e.toJson()).toList(),
  'featured_brands': ?instance.featuredBrands?.map((e) => e.toJson()).toList(),
  'buy_again': ?instance.buyAgain?.map((e) => e.toJson()).toList(),
};
