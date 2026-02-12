import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'model/weather.dart';
import 'repository/weather_repository_impl.dart';
import 'state/weather_state.dart';
import 'weather_cubit.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(WeatherRepositoryImpl()),
      child: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Search"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listenWhen: (previous, current) => previous.screen != current.screen,
          listener: (context, state) {
            state.screen.maybeWhen(
              loading: () {
                SmartDialog.showLoading(msg: '検索中...');
              },
              error: (message) {
                SmartDialog.dismiss();
                SmartDialog.showToast(
                  message,
                  displayTime: const Duration(seconds: 3), // 3秒間表示
                  clickMaskDismiss: true, // マスク部分をタップして閉じる
                );
              },
              orElse: () {
                SmartDialog.dismiss();
              },
            );
          },
          builder: (context, state) {
            return state.screen.when(
              initial: () => _buildInitialInput(),
              loading: () => _buildLoading(),
              error: (_) => _buildInitialInput(),
              success: (weather) => _buildColumnWithData(weather),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInitialInput() {
    return const Center(
      child: CityInputField(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column _buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: const TextStyle(fontSize: 80),
        ),
        const CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  const CityInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => context.read<WeatherCubit>().getWeather(value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
