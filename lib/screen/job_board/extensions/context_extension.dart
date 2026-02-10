import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  TextTheme get textTheme => Theme.of(this).textTheme;
}