import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  // Default state
  CounterCubit() : super(0);

  void increment() {
    // Update the state
    emit(state + 1);
  }
}
