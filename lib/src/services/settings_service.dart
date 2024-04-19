import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {

  late SharedPreferences _sharedPreferences;

  Future<SettingsService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<ThemeMode> themeMode() async {
    String themeModeString = _sharedPreferences.getString('themeMode') ?? ThemeMode.system.name;
    if (themeModeString == "light") {
      return ThemeMode.light;
    }
    if (themeModeString == "dark") {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    await _sharedPreferences.setString('themeMode', theme.name);
  }
}
