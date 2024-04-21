
import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';

class RefreshSubscriptionsCommand extends AbstractCommand {

  RefreshSubscriptionsCommand(super.context);

  Future<void> run() async {
    settingsModel.subscriptionPlans = await subscriptionsService.listSubscriptions();
  }

}