import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_models.freezed.dart';
part 'search_models.g.dart';

/// `GET /search/suggestions` response (docs/API_SPEC.md).
@freezed
class SearchSuggestions with _$SearchSuggestions {
  const factory SearchSuggestions({
    @Default(<String>[]) List<String> suggestions,
    @Default(<String>[]) List<String> popular,
  }) = _SearchSuggestions;

  factory SearchSuggestions.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionsFromJson(json);
}
