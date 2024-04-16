import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:sortmaster_photos/src/di.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_model.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_service.dart';

class OnboardingController with ChangeNotifier {

  final _onboardingService = di<OnboardingService>();
  final _pagesController = PageController();
  PageController get pagesController => _pagesController;

  late int _selectedPage = 0;
  void updateSelectedPage(int index) {
    _selectedPage = index;
    notifyListeners();
  }
  bool get isLastPage => (_selectedPage+1 == _pages.length) ? true : false;

  final List<Map<String, dynamic>> _pages = [
    {
      'urlImage': 'assets/onboarding/1.png',
      'title': 'Ready To travel',
      'description': 'Choose your destination, plan your trip.\nPick the best place for your holiday',
    },
    {
      'urlImage': 'assets/onboarding/2.png',
      'title': 'Select The Date',
      'description': 'Select the day.Pick your ticket.We give you the best price.We guaranteed!',
    },
    {
      'urlImage': 'assets/onboarding/3.png',
      'title': 'Feels Like Home',
      'description': 'Enjoy your holiday! Don\'t forget to take a beer and take a photo.',
    },
  ];
  List<Map<String, dynamic>> get pages => _pages;

  Future<void> validateOnboarding() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    await _onboardingService.updateOnboarding(OnboardingModel.onboarded(version: version));
    notifyListeners();
  }
}