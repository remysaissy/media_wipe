import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'settings_entity.g.dart';

@collection
class SettingsEntity {
  Id id = Isar.autoIncrement;

  @ignore
  ThemeMode themeMode;

  String get dbThemeMode {
    return themeMode.name.toLowerCase();
  }

  set dbThemeMode(String? value) {
    var mode = ThemeMode.values
        .where((e) => e.name.toLowerCase() == value)
        .firstOrNull;
    mode ??= ThemeMode.system;
    themeMode = mode;
  }

  bool hasPhotosAccess;

  bool hasInAppReview;

  // Debug only.
  bool debugDryRemoval;

  SettingsEntity({
    this.id = Isar.autoIncrement,
    this.themeMode = ThemeMode.system,
    this.hasPhotosAccess = false,
    this.hasInAppReview = false,
    this.debugDryRemoval = true,
  });
}
