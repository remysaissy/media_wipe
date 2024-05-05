import 'dart:convert';

import 'package:app/src/models/app_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:app/src/models/settings_model.dart';

class AppService {
  Future<List<OnboardingData>> refreshOnboardingPages() async {
    final onboardingString =
        await rootBundle.loadString('assets/data/onboarding.json');
    final List<dynamic> entries = jsonDecode(onboardingString);
    return entries.map((e) => OnboardingData.fromJson(e)).toList();
  }

  Future<List<SubscriptionData>> refreshSubscriptions() async {
    final subscriptionsString =
        await rootBundle.loadString('assets/data/subscriptions.json');
    final List<dynamic> entries = jsonDecode(subscriptionsString);
    return entries.map((e) => SubscriptionData.fromJson(e)).toList();
  }
}
