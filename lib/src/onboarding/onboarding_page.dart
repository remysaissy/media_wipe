import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {

  final String urlImage;
  final String title;
  final String description;

  const OnboardingPage({super.key, required this.urlImage,required this.title, required this.description });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          urlImage,
          width: 250,
          height: 200,
        ),
        const SizedBox(height: 30,),
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            description,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}