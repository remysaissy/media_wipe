class OnboardingModel {
  bool   confirmed;
  String? version;

  OnboardingModel({required this.confirmed, this.version});

  OnboardingModel.notOnboarded(): confirmed = false;
  OnboardingModel.onboarded({required this.version}): confirmed = true;

  OnboardingModel.fromJson(Map<String, dynamic> json)
      : confirmed = json['confirmed'] as bool,
        version = json['version'] as String;

  Map<String, dynamic> toJson() => {
    'confirmed': confirmed,
    'version': version,
  };
}