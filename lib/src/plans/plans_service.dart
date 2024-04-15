import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Plan {
  final String productID;
  final DateTime subscribedAt;

  Plan({required this.productID, required this.subscribedAt});
  Plan.subscribe({required this.productID}): subscribedAt = DateTime.now();

  Plan.fromJson(Map<String, dynamic> json):
        productID = json['productID'] as String,
        subscribedAt = DateTime.fromMillisecondsSinceEpoch(json['subscribedAt'] as int);

  Map<String, dynamic> toJson() => {
    'productID': productID,
    'subscribedAt': subscribedAt.millisecondsSinceEpoch
  };
}

/// A service that handles In App Purchases.
class PlansService {

  Future<Plan?> plan() async {
    final prefs = await SharedPreferences.getInstance();
    String? planString = prefs.getString('plan');
    if (planString != null) {
      return Plan.fromJson(jsonDecode(planString) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> updatePlan(Plan plan) async {
    final prefs = await SharedPreferences.getInstance();
    String planString = jsonEncode(plan.toJson());
    await prefs.setString('plan', planString);
  }

  /// Restore previous purchases.
  Future<Plan> restorePurchase() async {
    //Flow:
    // - check for restore against the store
    // - persist the restored plan information locally
    // - return the restored plan
    final plan = Plan.subscribe(productID: "free");
    updatePlan(plan);
    return plan;
  }

  Future<Plan> purchase(String productID) async {
    //Flow:
    // - buy the plan against the store
    // - create the plan object
    // - persist the plan information locally
    // - return the purchased plan
    final plan = Plan.subscribe(productID: productID);
    await updatePlan(plan);
    return plan;
  }
}
