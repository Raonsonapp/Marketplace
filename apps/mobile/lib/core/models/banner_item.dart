import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_item.freezed.dart';
part 'banner_item.g.dart';

/// A home-feed promotional banner (see docs/API_SPEC.md `GET /home`).
@freezed
class BannerItem with _$BannerItem {
  const factory BannerItem({
    required String id,
    required String imageUrl,
    String? title,
    String? deepLink,
  }) = _BannerItem;

  factory BannerItem.fromJson(Map<String, dynamic> json) => _$BannerItemFromJson(json);
}
