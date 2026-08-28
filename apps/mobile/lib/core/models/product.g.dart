// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  price: json['price'] as String,
  oldPrice: json['old_price'] as String?,
  ratingAvg: json['rating_avg'] == null
      ? 0.0
      : _ratingFromJson(json['rating_avg']),
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  inStock: json['in_stock'] as bool? ?? true,
  stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
  categoryId: json['category_id'] as String?,
  brandId: json['brand_id'] as String?,
  brandName: json['brand_name'] as String?,
  storeId: json['store_id'] as String?,
  unit: json['unit'] as String? ?? 'pcs',
  isFavorite: json['is_favorite'] as bool? ?? false,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': ?instance.description,
  'images': instance.images,
  'price': instance.price,
  'old_price': ?instance.oldPrice,
  'rating_avg': instance.ratingAvg,
  'rating_count': instance.ratingCount,
  'in_stock': instance.inStock,
  'stock_quantity': ?instance.stockQuantity,
  'category_id': ?instance.categoryId,
  'brand_id': ?instance.brandId,
  'brand_name': ?instance.brandName,
  'store_id': ?instance.storeId,
  'unit': instance.unit,
  'is_favorite': instance.isFavorite,
};
