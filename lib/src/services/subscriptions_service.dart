
import 'dart:convert';

import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sortmaster_photos/src/utils.dart';

class SubscriptionsService {

  Future<List<SubscriptionData>> listSubscriptions() async {
    Utils.logger.i('list subscriptions');
    final subscriptionsString = await rootBundle.loadString('assets/data/subscriptions.json');
    Utils.logger.i('list subscriptions==> $subscriptionsString');
    final List<dynamic> entries = jsonDecode(subscriptionsString);
    Utils.logger.i('list subscriptions==> ${entries.length}');
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