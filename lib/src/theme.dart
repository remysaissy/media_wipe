import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData light() {
    return ThemeData(useMaterial3: true, brightness: Brightness.light);
  }

  static ThemeData dark() {
    return ThemeData(useMaterial3: true, brightness: Brightness.dark);
  }
}
