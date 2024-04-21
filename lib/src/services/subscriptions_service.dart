
import 'dart:convert';

import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class SubscriptionsService {

  Future<List<SubscriptionData>> listSubscriptions() async {
    final subscriptionsString = await rootBundle.loadString('assets/data/subscriptions.json');
    final List<dynamic> entries = jsonDecode(subscriptionsString);
    return entries.map((e) => SubscriptionData.fromJson(e)).toList();
  }

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