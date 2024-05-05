
import 'package:flutter/material.dart';
import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/settings_model.dart';

class RestoreSubscriptionCommand extends AbstractCommand {

  RestoreSubscriptionCommand(super.context);

  Future<bool> run() async {
    final restoredProductId = await subscriptionsService.restorePurchase();
    if (restoredProductId != null) {
      settingsModel.productId = restoredProductId;
      settingsModel.subscribedAt = DateTime.now();
    }
    return (restoredProductId != null);
  }

}