import 'package:flutter/material.dart';
import 'app_constants.dart';

class AppTheme {
  var _lightTheme = ThemeData.light().copyWith(
    primaryColor: AppColors.primary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      titleTextStyle: TextStyle(
          color: AppColors.black,
          fontWeight: AppFontUtils.medium,
          fontSize: AppFontUtils.headline),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          color: AppColors.black,
          fontWeight: AppFontUtils.medium,
          fontSize: AppFontUtils.headline),
      titleMedium: TextStyle(
          color: AppColors.black,
          fontWeight: AppFontUtils.regular,
          fontSize: AppFontUtils.subtitle),
      bodyLarge: TextStyle(
          color: AppColors.black,
          fontWeight: AppFontUtils.regular,
          fontSize: AppFontUtils.body),
      labelLarge: TextStyle(
          color: AppColors.black,
          fontWeight: AppFontUtils.medium,
          fontSize: AppFontUtils.button),
      bodySmall: TextStyle(
          color: AppColors.black,
          fontWeight: AppFontUtils.regular,
          fontSize: AppFontUtils.caption),
    ),
  );

  //getters
  ThemeData get theme => _lightTheme;
}
