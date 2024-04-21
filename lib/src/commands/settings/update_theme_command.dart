
import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/commands/abstract_command.dart';

class UpdateThemeCommand extends AbstractCommand {

  UpdateThemeCommand(super.context);

  Future<void> run({required ThemeMode newThemeMode}) async {
    settingsModel.themeMode = newThemeMode;
  }

}