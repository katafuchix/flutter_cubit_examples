import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/cocktail_repository.dart';
import 'state/cocktail_state.dart';

class CocktailSearchCubit extends Cubit<CocktailState> {
  final CocktailRepository _repository;

  CocktailSearchCubit(this._repository)
      : super(const CocktailState(
          screen: ScreenState.initial(''),
          dialog: DialogState.idle(),
        ));

  void setSearchWord(String word) {
    // 現在の screen 状態を維持したまま word だけ更新
    // state.screen.copyWith(word: word) が使えるよう定義されている想定
    emit(state.copyWith(
      screen: state.screen.copyWith(word: word),
    ));
  }

  // ボタンの判定もStateから取れる
  bool get isSearchButtonEnabled => state.screen.word.isNotEmpty;

  // 検索実行
  Future<void> searchCocktail() async {
    if (!isSearchButtonEnabled) return;

    final currentWord = state.screen.word;

    // 画面（screen）だけをロード中に変更
    emit(state.copyWith(screen: ScreenState.loading(currentWord)));
    // 遅延確認
    //await Future.delayed(Duration(seconds: 3));
    try {
      final results = await _repository.searchCocktail(searchWord: currentWord);

      if (results.isEmpty) {
        emit(state.copyWith(
          screen: ScreenState.error(message: '結果なし', word: currentWord),
        ));
      } else {
        emit(state.copyWith(
          screen: ScreenState.success(results: results, word: currentWord),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        screen: ScreenState.error(message: e.toString(), word: currentWord),
      ));
    }
  }
}
