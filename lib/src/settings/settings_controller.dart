import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/di.dart';
import 'package:sortmaster_photos/src/settings/settings_service.dart';

class SettingsController with ChangeNotifier {

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService = di<SettingsService>();

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode != null) {
      _themeMode = newThemeMode;
      await _settingsService.updateThemeMode(newThemeMode);
      notifyListeners();
    }
  }

  Future<void> load() async {
    _themeMode = await _settingsService.themeMode();
    notifyListeners();
  }
}
