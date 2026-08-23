// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BannerItem _$BannerItemFromJson(Map<String, dynamic> json) => _BannerItem(
  id: json['id'] as String,
  imageUrl: json['image_url'] as String,
  title: json['title'] as String?,
  deepLink: json['deep_link'] as String?,
);

Map<String, dynamic> _$BannerItemToJson(_BannerItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.imageUrl,
      'title': ?instance.title,
      'deep_link': ?instance.deepLink,
    };
