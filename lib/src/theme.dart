import 'package:flutter/material.dart';

class MyTheme {

  static ThemeData light() {
    return ThemeData(
        colorSchemeSeed: Colors.teal.shade700,
        brightness: Brightness.light,
        useMaterial3: true
    );
  }

  static ThemeData dark() {
    return ThemeData(
        colorSchemeSeed: Colors.teal.shade700,
        brightness: Brightness.dark,
        useMaterial3: true
    );
  }
}
