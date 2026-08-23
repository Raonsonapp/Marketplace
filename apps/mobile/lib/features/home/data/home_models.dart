import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/banner_item.dart';
import '../../../core/models/brand.dart';
import '../../../core/models/category.dart';
import '../../../core/models/product.dart';
import '../../../core/models/store.dart';

part 'home_models.freezed.dart';
part 'home_models.g.dart';

/// The dynamic home feed from `GET /home` (docs/API_SPEC.md). Every section
/// is nullable/omittable — the backend leaves a section out entirely when
/// it has nothing to show, rather than sending an empty array.
@freezed
class HomeFeed with _$HomeFeed {
  const factory HomeFeed({
    List<BannerItem>? banners,
    List<Category>? categories,
    List<Product>? popular,
    List<Product>? discounted,
    List<Product>? recommended,
    List<Product>? recentlyViewed,
    List<Product>? personalOffers,
    List<Store>? nearbyStores,
    List<Brand>? featuredBrands,
    List<Product>? buyAgain,
  }) = _HomeFeed;

  const HomeFeed._();

  factory HomeFeed.fromJson(Map<String, dynamic> json) => _$HomeFeedFromJson(json);

  bool get isEntirelyEmpty =>
      (banners?.isEmpty ?? true) &&
      (categories?.isEmpty ?? true) &&
      (popular?.isEmpty ?? true) &&
      (discounted?.isEmpty ?? true) &&
      (recommended?.isEmpty ?? true) &&
      (recentlyViewed?.isEmpty ?? true) &&
      (personalOffers?.isEmpty ?? true) &&
      (nearbyStores?.isEmpty ?? true) &&
      (featuredBrands?.isEmpty ?? true) &&
      (buyAgain?.isEmpty ?? true);
}
