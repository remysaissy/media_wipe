import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/models/app_model.dart';

class OnboardingItemView extends StatelessWidget {
  final OnboardingData item;

  const OnboardingItemView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Flexible(child: Image.asset(item.urlImage, fit: BoxFit.cover)),
      Flexible(
          child:
              Text(item.title, style: Theme.of(context).textTheme.titleMedium)),
      Flexible(
          child: Text(item.description,
              style: Theme.of(context).textTheme.bodyMedium))
    ]);
  }
}
