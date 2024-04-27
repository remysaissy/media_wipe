import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData light(VisualDensity density) {
    return ThemeData(useMaterial3: true, visualDensity: density, brightness: Brightness.light);
  }

  static ThemeData dark(VisualDensity density) {
    return ThemeData(useMaterial3: true, visualDensity: density, brightness: Brightness.dark);
  }
}
