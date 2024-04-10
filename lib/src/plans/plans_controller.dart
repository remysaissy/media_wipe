import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/ioc.dart';
import 'package:sortmaster_photos/src/plans/plans_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class PlansController with ChangeNotifier {

  final PlansService _plansService = getIt<PlansService>();

  late List<Map<String, dynamic>> _plans;
  List<String> get planLabels => _plans.map((e) => e['name'].toString()).toList();
  List<Map<String, dynamic>> get plans => _plans;

  late int _selectedPlan;
  int get selectedPlan => _selectedPlan;
  String get selectedPlanLabel => _plans[_selectedPlan]['name'];
  late String? _productID;

  bool shouldSkipPlans() {
    // TODO: the check should be as follows:
    //   - no productID => false
    //   - free productID AND expirationDat reached => false
    //   - anything else => true
    if (_productID != null) {
      return true;
    }
    return true;
  }

  /// Load the plans. It may load from a local database or the internet.
  /// The controller only knows it can load plans from the service.
  Future<void> load() async {
    _productID = await _plansService.getPurchasedProductID();
    _selectedPlan = 0;
    _plans = [
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
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> updateSelectedPlan(index) async {
    print("Update plan to ${index}");
    _selectedPlan = index;
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> restorePurchase() async {
    print('Restore purchase');
    await _plansService.restorePurchase();
    _productID = await _plansService.getPurchasedProductID();
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> purchasePlan() async {
    await _plansService.purchase(_plans[_selectedPlan]['productID']);
    _productID = await _plansService.getPurchasedProductID();
    print('Purchase plan');
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}