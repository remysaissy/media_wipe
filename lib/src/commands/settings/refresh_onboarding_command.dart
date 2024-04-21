
import 'dart:convert';

import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class RefreshOnboardingCommand extends AbstractCommand {

  RefreshOnboardingCommand(super.context);

  Future<void> run() async {
    final onboardingString = await rootBundle.loadString('assets/data/onboarding.json');
    final List<dynamic> entries = jsonDecode(onboardingString);
    settingsModel.onboardingSteps = entries.map((e) => OnboardingData.fromJson(e)).toList();
  }

}