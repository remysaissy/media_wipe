import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortmaster_photos/src/models/onboarding_model.dart';

class OnboardingService {

  late SharedPreferences _sharedPreferences;

  Future<OnboardingService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<OnboardingModel> onboarding() async {
    String? onboardingString = _sharedPreferences.getString('onboarding');
    if (onboardingString != null) {
      return OnboardingModel.fromJson(jsonDecode(onboardingString) as Map<String, dynamic>);
    } else {
      return OnboardingModel.notOnboarded();
    }
  }

  Future<void> updateOnboarding(OnboardingModel onboarding) async {
    String onboardingString = jsonEncode(onboarding.toJson());
    await _sharedPreferences.setString('onboarding', onboardingString);
  }
}
