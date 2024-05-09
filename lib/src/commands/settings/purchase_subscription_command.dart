
import 'package:flutter/material.dart';
import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/settings42_model.dart';

class PurchaseSubscriptionCommand extends AbstractCommand {

  PurchaseSubscriptionCommand(super.context);

  Future<bool> run({required String productId}) async {
    final success = await subscriptionsService.purchase(productId: productId);
    if (success) {
      // settings42Model.productId = productId;
      // settings42Model.subscribedAt = DateTime.now();
    }
    return success;
  }

}