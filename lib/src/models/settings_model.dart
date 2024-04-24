import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/models/abstract_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class OnboardingData {
  final String urlImage;
  final String title;
  final String description;

  OnboardingData({required this.urlImage, required this.title, required this.description});

  OnboardingData.fromJson(Map<String, dynamic> json):
        urlImage = json['urlImage'],
        title = json['title'],
        description = json['description'];
}

class SubscriptionData {
  final String productId;
  final String name;
  final String title;
  final String price;

  SubscriptionData({required this.productId, required this.name, required this.title, required this.price});

  SubscriptionData.fromJson(Map<String, dynamic> json):
      productId = json['productId'],
      name = json['name'],
      title = json['title'],
      price = json['price'];
}

class SettingsModel extends AbstractModel {

  SettingsModel() {
    enableSerialization('settings.dat');
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    scheduleSave();
    notifyListeners();
  }

  bool _isOnboarded = false;
  bool get isOnboarded => _isOnboarded;
  set isOnboarded(bool isOnboarded) {
    _isOnboarded = isOnboarded;
    scheduleSave();
    notifyListeners();
  }

  String _productId = '';
  String get productId => _productId;
  set productId(String productId) {
    _productId = productId;
    scheduleSave();
    notifyListeners();
  }

  bool get hasSubscription => (_productId == 'free' && _subscribedAt.difference(DateTime.now()).compareTo(const Duration(days: 3)) < 0) || _productId.isNotEmpty;
  SubscriptionData? get currentSubscription => (hasSubscription && _subscriptionPlans.isNotEmpty) ? _subscriptionPlans.where((element) => element.productId == _productId).firstOrNull : null;

  DateTime _subscribedAt = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime get subscribedAt => _subscribedAt;
  set subscribedAt(DateTime subscribedAt) {
    _subscribedAt = subscribedAt;
    scheduleSave();
    notifyListeners();
  }

  bool _canAccessPhotoLibrary = false;
  bool get canAccessPhotoLibrary => _canAccessPhotoLibrary;
  set canAccessPhotoLibrary(bool canAccessPhotoLibrary) {
    _canAccessPhotoLibrary = canAccessPhotoLibrary;
    notifyListeners();
  }

  List<SubscriptionData> _subscriptionPlans = [];
  List<SubscriptionData> get subscriptionPlans => _subscriptionPlans;
  set subscriptionPlans(List<SubscriptionData> subscriptionPlans) {
    _subscriptionPlans = subscriptionPlans;
    notifyListeners();
  }

  List<OnboardingData> _onboardingSteps = [];
  List<OnboardingData> get onboardingSteps => _onboardingSteps;
  set onboardingSteps(List<OnboardingData> onboardingSteps) {
    _onboardingSteps = onboardingSteps;
    notifyListeners();
  }

  @override
  void reset([bool notify = true]) {
    Utils.logger.i("[SettingsModel] Reset");
    copyFromJson({});
    super.reset(notify);
  }

  /////////////////////////////////////////////////////////////////////
  // Define serialization methods

  //Json Serialization
  @override
  SettingsModel copyFromJson(Map<String, dynamic> json) {
    _themeMode = json.containsKey('_themeMode') ? json['_themeMode'].toThemeMode() : ThemeMode.system;
    _isOnboarded = json.containsKey('_isOnboarded') ? json['_isOnboarded'] as bool : false;
    _productId = json.containsKey('_productId') ? json['_productId'] : '';
    _subscribedAt = json.containsKey('_subscribedAt') ? DateTime.fromMillisecondsSinceEpoch(json['_subscribedAt']) :  DateTime.fromMillisecondsSinceEpoch(0);
    return this;
  }

  @override
  Map<String, dynamic> toJson() => {
    '_themeMode': _themeMode.name.toLowerCase(),
    '_isOnboarded': _isOnboarded,
    '_productId': _productId,
    '_subscribedAt': _subscribedAt.millisecondsSinceEpoch
    };
}

extension ToThemeMode on String {
  ThemeMode toThemeMode() {
    final s = toLowerCase();
    if (s == "light") {
      return ThemeMode.light;
    } else if (s == "dark") {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }
}
