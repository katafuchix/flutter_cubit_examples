import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'repository/user_repository_impl.dart';
import 'state/user_state.dart';
import 'user_cubit.dart';

// cf. https://dev.to/dev-vickie/fetching-apis-with-cubits-in-flutter-b8f
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(UserRepositoryImpl(Dio())),
      child: const UserMain(),
    );
  }
}

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => UserMainState();
}

class UserMainState extends State<UserMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Users"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<UserCubit, UserState>(
        // リスナが呼び出される条件
        listenWhen: (previous, current) => previous.screen != current.screen,
        listener: (context, state) {
          // ローディング制御
          final isScreenLoading = state.screen is ScreenLoading;
          if (isScreenLoading) {
            SmartDialog.showLoading(msg: '検索中...');
          } else {
            SmartDialog.dismiss();
          }
        },
        builder: (context, state) {
          return state.screen.when(
            initial: () => Center(
              child: ElevatedButton(
                  child: const Text("Get Users"),
                  onPressed: () => context.read<UserCubit>().fetchUsers()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: ((errorMessage) => Center(
                  child: Text(errorMessage),
                )),
            success: (users) {
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index].name),
                    subtitle: Text(users[index].email),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
