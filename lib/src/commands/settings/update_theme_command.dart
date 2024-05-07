
import 'package:flutter/material.dart';
import 'package:app/src/commands/abstract_command.dart';

class UpdateThemeCommand extends AbstractCommand {

  UpdateThemeCommand(super.context);

  Future<void> run({required ThemeMode newThemeMode}) async {
    settingsModel.settings.themeMode = newThemeMode;
    await settingsModel.updateSettings();
  }
}