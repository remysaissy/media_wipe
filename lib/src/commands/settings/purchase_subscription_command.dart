
import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';

class PurchaseSubscriptionCommand extends AbstractCommand {

  PurchaseSubscriptionCommand(super.context);

  Future<bool> run({required String productId}) async {
    final success = await subscriptionsService.purchase(productId: productId);
    if (success) {
      settingsModel.productId = productId;
      settingsModel.subscribedAt = DateTime.now();
    }
    return success;
  }

}