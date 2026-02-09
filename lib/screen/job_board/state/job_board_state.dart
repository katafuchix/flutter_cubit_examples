import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/job.dart';

part 'job_board_state.freezed.dart';

@freezed
class JobBoardState with _$JobBoardState {
  const factory JobBoardState({
    @Default(ScreenState.initial()) ScreenState screen,
    @Default(DialogState.idle()) DialogState dialog,
  }) = _JobBoardState;
}

@freezed
sealed class ScreenState with _$ScreenState {
  const factory ScreenState.initial() = ScreenInitial;

  const factory ScreenState.loading() = ScreenLoading;

  const factory ScreenState.success({
    required List<Job> results,
  }) = ScreenSuccess;

  const factory ScreenState.error({
    required String message,
  }) = ScreenError;
}

@freezed
sealed class DialogState with _$DialogState {
  const factory DialogState.idle() = DialogIdle;

  const factory DialogState.loading() = DialogLoading;

  const factory DialogState.success(String message) = DialogSuccess;

  const factory DialogState.error(String message) = DialogError;
}
