import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

/// A saved delivery address (`/addresses*` — docs/API_SPEC.md), matching
/// docs/DATABASE_SCHEMA.md's `addresses` table.
@freezed
class Address with _$Address {
  const factory Address({
    required String id,
    required String city,
    required String street,
    String? house,
    String? apartment,
    String? entrance,
    String? floor,
    String? comment,
    double? lat,
    double? lng,
    @Default(false) bool isDefault,
  }) = _Address;

  const Address._();

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  String get displayLine {
    final parts = [street, if (house != null && house!.isNotEmpty) house!];
    return '${parts.join(' ')}, $city';
  }
}
