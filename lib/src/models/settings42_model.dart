import 'package:flutter/material.dart';
import 'package:app/src/models/abstract_model.dart';
import 'package:app/src/utils.dart';

class SubscriptionData {
  final String productId;
  final String name;
  final String title;
  final String price;

  SubscriptionData(
      {required this.productId,
      required this.name,
      required this.title,
      required this.price});

  SubscriptionData.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        name = json['name'],
        title = json['title'],
        price = json['price'];
}

class Settings42Model extends AbstractModel {
  Settings42Model() {
    enableSerialization('settings.dat');
  }

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    scheduleSave();
    notifyListeners();
  }

  late bool _isOnboarded;
  bool get isOnboarded => _isOnboarded;
  set isOnboarded(bool isOnboarded) {
    _isOnboarded = isOnboarded;
    scheduleSave();
    notifyListeners();
  }

  late String _productId;
  String get productId => _productId;
  set productId(String productId) {
    _productId = productId;
    scheduleSave();
    notifyListeners();
  }

  bool get hasSubscription =>
      (_productId == 'free' &&
          _subscribedAt
                  .difference(DateTime.now())
                  .compareTo(const Duration(days: 3)) <
              0) ||
      _productId.isNotEmpty;

  SubscriptionData? get currentSubscription =>
      (hasSubscription && _subscriptionPlans.isNotEmpty)
          ? _subscriptionPlans
              .where((element) => element.productId == _productId)
              .firstOrNull
          : null;

  late DateTime _subscribedAt;
  DateTime get subscribedAt => _subscribedAt;
  set subscribedAt(DateTime subscribedAt) {
    _subscribedAt = subscribedAt;
    scheduleSave();
    notifyListeners();
  }

  late bool _canAccessPhotoLibrary;
  bool get canAccessPhotoLibrary => _canAccessPhotoLibrary;
  set canAccessPhotoLibrary(bool canAccessPhotoLibrary) {
    _canAccessPhotoLibrary = canAccessPhotoLibrary;
    notifyListeners();
  }

  late List<SubscriptionData> _subscriptionPlans;
  List<SubscriptionData> get subscriptionPlans => _subscriptionPlans;
  set subscriptionPlans(List<SubscriptionData> subscriptionPlans) {
    _subscriptionPlans = subscriptionPlans;
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
  Settings42Model copyFromJson(Map<String, dynamic> json) {
    _themeMode = json.containsKey('_themeMode')
        ? json['_themeMode'].toThemeMode()
        : ThemeMode.light;
    _isOnboarded =
        json.containsKey('_isOnboarded') ? json['_isOnboarded'] as bool : false;
    _productId = json.containsKey('_productId') ? json['_productId'] : '';
    _subscribedAt = json.containsKey('_subscribedAt')
        ? DateTime.fromMillisecondsSinceEpoch(json['_subscribedAt'])
        : DateTime.fromMillisecondsSinceEpoch(0);
    _canAccessPhotoLibrary = false;
    _subscriptionPlans = [];
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
