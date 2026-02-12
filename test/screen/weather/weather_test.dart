import 'package:flutter_cubit_examples/screen/weather/model/weather.dart';
import 'package:flutter_cubit_examples/screen/weather/repository/weather_repository.dart';
import 'package:flutter_cubit_examples/screen/weather/state/weather_state.dart';
import 'package:flutter_cubit_examples/screen/weather/weather_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late WeatherCubit cubit;
  late MockWeatherRepository mockRepository;

  late Weather weather;

  setUp(() {
    mockRepository = MockWeatherRepository();
    cubit = WeatherCubit(mockRepository);
    weather = const Weather(
      cityName: 'Tokyo',
      temperatureCelsius: 20,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('WeatherCubit', () {
    test('初期状態が正しいこと', () {
      expect(
          cubit.state,
          const WeatherState(
            // 初期状態：Screenはinitial、Dialogはidle
            screen: ScreenState.initial(),
            dialog: DialogState.idle(),
          ));
    });

    blocTest<WeatherCubit, WeatherState>(
      '正常系：ロード成功時にLoading状態を経て、ScreenSuccessが発行されること',
      build: () {
        when(() => mockRepository.fetchWeather('Tokyo'))
            .thenAnswer((_) async => weather);
        return cubit;
      },
      act: (cubit) => cubit.getWeather('Tokyo'),
      expect: () => [
        const WeatherState(
            screen: ScreenState.loading(), dialog: DialogState.idle()),
        WeatherState(
            screen: ScreenState.success(weather: weather),
            dialog: const DialogState.idle()),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      '検索失敗時：Loading状態を経て、エラーメッセージが格納されること',
      build: () {
        when(() => mockRepository.fetchWeather('Tokyo'))
            .thenThrow(Exception('Network Error'));
        return cubit;
      },
      act: (cubit) => cubit.getWeather('Tokyo'),
      expect: () => [
        const WeatherState(
            screen: ScreenState.loading(), dialog: DialogState.idle()),
        const WeatherState(
            screen: ScreenError(message: 'Exception: Network Error'),
            dialog: DialogState.idle())
      ],
    );
  });
}
