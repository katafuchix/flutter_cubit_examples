import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result_error.freezed.dart';
part 'search_result_error.g.dart';

@freezed
class SearchResultError with _$SearchResultError {
  const factory SearchResultError({
    required String message,
  }) = _SearchResultError;

  factory SearchResultError.fromJson(Map<String,dynamic> json) => _$SearchResultErrorFromJson(json);
}