import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {

  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    String themeModeString = prefs.getString('themeMode') ?? ThemeMode.system.name;
    if (themeModeString == "light") {
      return ThemeMode.light;
    }
    if (themeModeString == "dark") {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', theme.name);
  }
}
