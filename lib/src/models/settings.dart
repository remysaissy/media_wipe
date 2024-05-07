import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Settings {
  @Id()
  int id;

  @Transient()
  ThemeMode themeMode;

  String get dbThemeMode {
    return themeMode.name.toLowerCase();
  }

  set dbThemeMode(String? value) {
    var mode = ThemeMode.values.where((e) => e.name.toLowerCase() == value).firstOrNull;
    mode ??= ThemeMode.system;
    themeMode = mode;
  }

  bool hasPhotosAccess;

  Settings({this.id = 0, this.themeMode = ThemeMode.system, this.hasPhotosAccess = false});
}