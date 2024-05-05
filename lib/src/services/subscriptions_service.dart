
import 'dart:convert';

import 'package:app/src/models/settings_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class SubscriptionsService {

  Future<String?> restorePurchase() async {
    //     //Flow:
//     // - check for restore against the store
//     // - persist the restored plan information locally
//     // - return the restored plan
    return 'free';
  }

  Future<bool> purchase({required String productId}) async {
    //     //Flow:
//     // - buy the plan against the store
//     // - create the plan object
//     // - persist the plan information locally
//     // - return the purchased plan
    return true;
  }
}