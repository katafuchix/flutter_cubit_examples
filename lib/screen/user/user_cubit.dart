import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/user_repository.dart';
import 'state/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository)
      : super(const UserState(
          screen: ScreenState.initial(),
          dialog: DialogState.idle(),
        ));

  // 検索実行
  Future<void> fetchUsers() async {
    // 画面（screen）だけをロード中に変更
    emit(state.copyWith(screen: ScreenState.loading()));
    // 遅延確認
    //await Future.delayed(Duration(seconds: 3));
    try {
      final results = await _repository.getUsers();

      if (results.isEmpty) {
        emit(state.copyWith(
          screen: ScreenState.error(message: '結果なし'),
        ));
      } else {
        emit(state.copyWith(
          screen: ScreenState.success(
            results: results,
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        screen: ScreenState.error(
          message: e.toString(),
        ),
      ));
    }
  }
}
