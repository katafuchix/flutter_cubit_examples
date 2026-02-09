import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/job_repository.dart';
import 'state/job_board_state.dart';

class JobBoardCubit extends Cubit<JobBoardState> {
  final JobRepository _repository;

  JobBoardCubit(this._repository)
      : super(const JobBoardState(
          screen: ScreenState.initial(),
          dialog: DialogState.idle(),
        ));

  // 検索実行
  Future<void> fetchJobs() async {
    // 画面（screen）だけをロード中に変更
    emit(state.copyWith(screen: ScreenState.loading()));
    // 遅延確認
    //await Future.delayed(Duration(seconds: 3));
    try {
      final results = await _repository.getJobs();

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
