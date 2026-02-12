import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_examples/screen/job_board/extensions/list_extension.dart';
import 'model/job.dart';
import 'repository/job_repository.dart';
import 'state/job_board_state.dart';

class JobBoardCubit extends Cubit<JobBoardState> {
  final JobRepository _repository;

  List<Job> _jobs = [];

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
      _jobs = await _repository.getJobs();

      if (_jobs.isEmpty) {
        emit(state.copyWith(
          screen: ScreenState.error(message: '結果なし'),
        ));
      } else {
        emit(state.copyWith(
          screen: ScreenState.success(
            results: _jobs,
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

  /*
  void changeTypeOfJob(int index, JobType type) {
    _jobs[index] = _jobs[index].copyWith(jobType: type);
    print(_jobs[index]);
    // List.from(_jobs) とすることで、中身は同じでも「別のリスト」として認識される
    emit(state.copyWith(
      screen: ScreenState.success(
        results: List.from(_jobs),
      ),
    ));
  }*/

  void changeTypeOfJob(int index, JobType type) {
    // 1. 現在の State から最新のリストを取得する
    final currentJobs = state.screen.maybeWhen(
      success: (jobs) => jobs,
      orElse: () => <Job>[],
    );

    // 2. 元のリストを一切触らず、新しいリストを生成する
    final updatedJobs = currentJobs.asMap().entries.map((entry) {
      if (entry.key == index) {
        // 該当の index だけ copyWith したものに差し替える
        return entry.value.copyWith(jobType: type);
      }
      return entry.value;
    }).toList();

    // 3. emit する
    print('Emit新リスト: $updatedJobs'); // ここまでログが出るか確認
    emit(state.copyWith(
      screen: ScreenState.success(results: updatedJobs),
    ));
  }
}
