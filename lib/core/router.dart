import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

import '../screen/counter/counter_screen.dart';
import '../screen/main_page.dart';
import '../screen/user/user_screen.dart';

final router = GoRouter(initialLocation: '/', observers: [
  FlutterSmartDialog.observer
], routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const MainPage(),
  ),
  GoRoute(
    path: '/counter',
    pageBuilder: (context, state) {
      return CupertinoPage(
        key: state.pageKey,
        child: const CounterScreen(),
      );
    },
  ),
  GoRoute(
    path: '/user',
    pageBuilder: (context, state) {
      return CupertinoPage(
        key: state.pageKey,
        child: const UserScreen(),
      );
    },
  ),
]);
