import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/weather_repository.dart';
import 'state/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _repository;

  WeatherCubit(this._repository)
      : super(const WeatherState(
          screen: ScreenState.initial(),
          dialog: DialogState.idle(),
        ));

  // 検索実行
  Future<void> getWeather(String cityName) async {
    // 画面（screen）だけをロード中に変更
    emit(state.copyWith(screen: const ScreenState.loading()));
    // 遅延確認
    //await Future.delayed(Duration(seconds: 3));
    try {
      final weather = await _repository.fetchWeather(cityName);
      emit(state.copyWith(
        screen: ScreenState.success(
          weather: weather,
        ),
      ));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(
        screen: ScreenState.error(
          message: e.toString(),
        ),
      ));
    }
  }
}
