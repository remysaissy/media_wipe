import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortmaster_photos/src/plans/plans_model.dart';

/// A service that handles In App Purchases.
class PlansService {

  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<Plan?> plan() async {
    String? planString = _sharedPreferences.getString('plan');
    if (planString != null) {
      return Plan.fromJson(jsonDecode(planString) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> updatePlan(Plan plan) async {
    String planString = jsonEncode(plan.toJson());
    await _sharedPreferences.setString('plan', planString);
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
