import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding {
  bool   confirmed;
  String? version;

  Onboarding({required this.confirmed, this.version});

  Onboarding.notOnboarded(): confirmed = false;
  Onboarding.onboarded({required this.version}): confirmed = true;

  Onboarding.fromJson(Map<String, dynamic> json)
      : confirmed = json['confirmed'] as bool,
        version = json['version'] as String;

  Map<String, dynamic> toJson() => {
    'confirmed': confirmed,
    'version': version,
  };
}

class OnboardingService {

  Future<Onboarding> onboarding() async {
    final prefs = await SharedPreferences.getInstance();
    String? onboardingString = prefs.getString('onboarding');
    if (onboardingString != null) {
      return Onboarding.fromJson(jsonDecode(onboardingString) as Map<String, dynamic>);
    } else {
      return Onboarding.notOnboarded();
    }
  }

  Future<void> updateOnboarding(Onboarding onboarding) async {
    final prefs = await SharedPreferences.getInstance();
    String onboardingString = jsonEncode(onboarding.toJson());
    await prefs.setString('onboarding', onboardingString);
  }
}
