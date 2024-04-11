import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/di.dart';
import 'package:sortmaster_photos/src/plans/plans_service.dart';

class PlansController with ChangeNotifier {

  final PlansService _plansService = di<PlansService>();

  final List<Map<String, dynamic>> _plans = [
    {
      'productID': 'free',
      'name': 'free',
      'title': 'Enjoy a 3-day trial',
      'price': 'Free',
    },
    {
      'productID': 'weekly',
      'name': 'weekly',
      'title': 'Enjoy the full version for a week',
      'price': '4.99 eur',
    },
    {
      'productID': 'lifetime',
      'name': 'lifetime',
      'title': 'Fully own your copy',
      'price': '99 eur',
    },
  ];
  List<String> get planNames => _plans.map((e) => e['name'].toString()).toList();
  Map<String, dynamic> get selectedPlanDescription => _plans[_selectedPlan];

  late int _selectedPlan = 0;
  int get selectedPlan => _selectedPlan;
  void updateSelectedPlan(index) {
    _selectedPlan = index;
    notifyListeners();
  }

  Future<bool> shouldSkipPlans() async {
    final currentPlan = await _plansService.plan();
    if (currentPlan != null) {
      return true;
    }
    return false;
  }

  Future<void> restorePurchase() async {
    final plan = await _plansService.restorePurchase();
    for (int index = 0; index < _plans.length; index++) {
      if (_plans[index]['productID'] == plan.productID) {
        _selectedPlan = index;
        break;
      }
    }
    notifyListeners();
  }

  Future<void> purchasePlan() async {
    await _plansService.purchase(_plans[_selectedPlan]['productID']);
    notifyListeners();
  }
}