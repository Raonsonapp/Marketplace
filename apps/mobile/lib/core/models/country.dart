import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';
part 'country.g.dart';

/// One deliverable city inside a [Country] (`GET /countries` — the `cities`
/// array of each country). [lat]/[lng] is the city centre, used to position
/// the address map before the user has a GPS fix.
@freezed
abstract class City with _$City {
  const factory City({
    required String id,
    @JsonKey(name: 'name_tg') required String nameTg,
    @JsonKey(name: 'name_ru') required String nameRu,
    @JsonKey(name: 'name_en') required String nameEn,
    required double lat,
    required double lng,
  }) = _City;

  const City._();

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  /// The city name in the active app language, falling back to the English
  /// spelling for a language the server has no translation for.
  String name(String languageCode) => switch (languageCode) {
        'ru' => nameRu,
        'en' => nameEn,
        _ => nameTg,
      };
}

/// A market YouShop operates in — Tajikistan or Russia (`GET /countries`).
/// Everything locale-dependent about money, phone input and the address map
/// comes from here rather than being hardcoded, so adding a third market is
/// a server change, not an app release.
@freezed
abstract class Country with _$Country {
  const factory Country({
    required String code,
    @JsonKey(name: 'name_tg') required String nameTg,
    @JsonKey(name: 'name_ru') required String nameRu,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(name: 'currency_tg') required String currencyTg,
    @JsonKey(name: 'currency_ru') required String currencyRu,
    @JsonKey(name: 'currency_en') required String currencyEn,
    @JsonKey(name: 'dial_code') required String dialCode,
    @JsonKey(name: 'center_lat') required double centerLat,
    @JsonKey(name: 'center_lng') required double centerLng,
    @Default(<City>[]) List<City> cities,
  }) = _Country;

  const Country._();

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  /// The country name in the active app language.
  String name(String languageCode) => switch (languageCode) {
        'ru' => nameRu,
        'en' => nameEn,
        _ => nameTg,
      };

  /// The currency label to print after an amount, in the active language
  /// ("сомонӣ", "₽", "RUB", …).
  String currencyLabel(String languageCode) => switch (languageCode) {
        'ru' => currencyRu,
        'en' => currencyEn,
        _ => currencyTg,
      };

  /// The flag emoji for the ISO code, built from the regional-indicator
  /// codepoints so no asset or lookup table is needed.
  String get flagEmoji {
    if (code.length != 2) return '';
    const base = 0x1F1E6;
    final upper = code.toUpperCase();
    return String.fromCharCodes([
      base + upper.codeUnitAt(0) - 0x41,
      base + upper.codeUnitAt(1) - 0x41,
    ]);
  }
}
