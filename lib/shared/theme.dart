import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData light() {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo));
  }

  static ThemeData dark() {
    return ThemeData(useMaterial3: true, brightness: Brightness.dark);
  }
}
