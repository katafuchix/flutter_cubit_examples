import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_cubit.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CounterCubit(), child: const CounterPage());
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterCubit, int>(
      bloc: context.read<CounterCubit>(),
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<CounterCubit>().increment();
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Counter"),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Center(
              child: Text(
                '$state',
                style: const TextStyle(
                  fontSize: 86.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
