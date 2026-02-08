import 'package:freezed_annotation/freezed_annotation.dart';

import 'drink.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult  with _$SearchResult {
  const factory SearchResult({
    required List<Drink> drinks
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String,dynamic> json) => _$SearchResultFromJson(json);
}