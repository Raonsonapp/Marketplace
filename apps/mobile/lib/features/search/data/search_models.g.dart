// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchSuggestions _$SearchSuggestionsFromJson(Map<String, dynamic> json) =>
    _SearchSuggestions(
      suggestions:
          (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      popular:
          (json['popular'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$SearchSuggestionsToJson(_SearchSuggestions instance) =>
    <String, dynamic>{
      'suggestions': instance.suggestions,
      'popular': instance.popular,
    };
