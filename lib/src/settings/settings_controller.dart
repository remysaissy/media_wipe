import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/di.dart';
import 'package:sortmaster_photos/src/permissions/permissions_service.dart';
import 'package:sortmaster_photos/src/permissions/permissions_model.dart';
import 'package:sortmaster_photos/src/settings/settings_service.dart';

class SettingsController with ChangeNotifier {

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService = di<SettingsService>();
  final PermissionsService _permissionsService = di<PermissionsService>();

  late ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode != null) {
      _themeMode = newThemeMode;
      await _settingsService.updateThemeMode(newThemeMode);
      notifyListeners();
    }
  }

  late PermissionsModel _currentPermissions;
  bool get isPhotosAuthorized => _currentPermissions.photos;

  Future<void> authorizePhotos() async {
      await _permissionsService.authorizePhotos();
      _currentPermissions = await _permissionsService.permissions();
      notifyListeners();
  }

  Future<void> init() async {
    _themeMode = await _settingsService.themeMode();
    _currentPermissions = await _permissionsService.permissions();
    notifyListeners();
  }
}
