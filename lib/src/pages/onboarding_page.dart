import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';

class OnboardingPage extends StatelessWidget {

  final OnboardingData onboardingData;

  const OnboardingPage({super.key, required this.onboardingData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          onboardingData.urlImage,
          width: 250,
          height: 200,
        ),
        const SizedBox(height: 30,),
        Text(
          onboardingData.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            onboardingData.description,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}