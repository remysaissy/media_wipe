
import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/commands/abstract_command.dart';

class UpdateOnboardingCommand extends AbstractCommand {

  UpdateOnboardingCommand(super.context);

  Future<void> run({required bool isOnboarded}) async {
    settingsModel.isOnboarded = isOnboarded;
  }

}