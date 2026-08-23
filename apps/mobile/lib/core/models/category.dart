import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// A catalog category node from `GET /categories` (self-referencing tree —
/// see docs/DATABASE_SCHEMA.md `categories.parent_id`).
@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? iconUrl,
    String? parentId,
    @Default(<Category>[]) List<Category> children,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
