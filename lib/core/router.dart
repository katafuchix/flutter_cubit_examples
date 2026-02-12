import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

import '../screen/cocktail_search/cocktail_search.screen.dart';
import '../screen/counter/counter_screen.dart';
import '../screen/job_board/job_board_screen.dart';
import '../screen/main_page.dart';
import '../screen/products_screen/products_screen.dart';
import '../screen/user/user_screen.dart';
import '../screen/weather/weather_screen.dart';

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
  GoRoute(
    path: '/cocktail',
    pageBuilder: (context, state) {
      return CupertinoPage(
        key: state.pageKey,
        child: const CocktailSearchScreen(),
      );
    },
  ),
  GoRoute(
    path: '/products',
    pageBuilder: (context, state) {
      return CupertinoPage(
        key: state.pageKey,
        child: const ProductsScreen(),
      );
    },
  ),
  GoRoute(
    path: '/job_board',
    pageBuilder: (context, state) {
      return CupertinoPage(
        key: state.pageKey,
        child: const JobBoardScreen(),
      );
    },
  ),
  GoRoute(
    path: '/weather',
    pageBuilder: (context, state) {
      return CupertinoPage(
        key: state.pageKey,
        child: const WeatherScreen(),
      );
    },
  ),
]);
