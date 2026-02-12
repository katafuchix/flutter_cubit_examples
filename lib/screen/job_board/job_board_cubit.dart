import 'package:flutter_bloc/flutter_bloc.dart';
import 'model/job.dart';
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
    emit(state.copyWith(screen: const ScreenState.loading()));
    // 遅延確認
    //await Future.delayed(Duration(seconds: 3));

    try {
      final results = await _repository.getJobs();

      if (results.isEmpty) {
        emit(state.copyWith(
          screen: const ScreenState.error(message: '結果なし'),
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

  // ステータス変更
  void changeTypeOfJob(int id, JobType type) {
    // 1. 現在の State から最新のリストを取得する
    final currentJobs = state.screen.maybeWhen(
      success: (jobs) => jobs,
      orElse: () => <Job>[],
    );

    // 2. 元のリストを一切触らず、新しいリストを生成する
    final updatedJobs = currentJobs.asMap().entries.map((entry) {
      if (entry.value.id == id) {
        // 該当の index だけ copyWith したものに差し替える
        return entry.value.copyWith(jobType: type);
      }
      return entry.value;
    }).toList();

    // 3. emit
    emit(state.copyWith(
      screen: ScreenState.success(results: updatedJobs),
    ));
  }
}
