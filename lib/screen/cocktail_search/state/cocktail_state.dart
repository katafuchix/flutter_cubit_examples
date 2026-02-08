import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/drink.dart';


part 'cocktail_state.freezed.dart';

@freezed
class CocktailState with _$CocktailState {
  const factory CocktailState({
    @Default(ScreenState.initial('')) ScreenState screen,
    @Default(DialogState.idle()) DialogState dialog,
  }) = _CocktailState;
}

@freezed
sealed class ScreenState with _$ScreenState {
  const factory ScreenState.initial(String word) = ScreenInitial;

  const factory ScreenState.loading(String word) = ScreenLoading;

  const factory ScreenState.success({
    required List<Drink> results,
    required String word,
  }) = ScreenSuccess;

  const factory ScreenState.error({
    required String message,
    required String word,
  }) = ScreenError;
}

@freezed
sealed class DialogState with _$DialogState {
  const factory DialogState.idle() = DialogIdle;

  const factory DialogState.loading() = DialogLoading;

  const factory DialogState.success(String message) = DialogSuccess;

  const factory DialogState.error(String message) = DialogError;
}
