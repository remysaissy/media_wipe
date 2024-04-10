import 'package:sortmaster_photos/src/components/my_cta_button.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/ioc.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_page.dart';
import 'package:sortmaster_photos/src/plans/plans_controller.dart';
import 'package:sortmaster_photos/src/plans/plans_service.dart';
import 'package:sortmaster_photos/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget{

  OnboardingView({super.key});

  final SettingsController _settingsController = getIt<SettingsController>();

  @override
  State <StatefulWidget> createState () => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {

  final _pagesController = PageController();
  bool _isLastPage = false;
  final List<Map<String, dynamic>> _pages = [
    {
      'urlImage': 'assets/onboarding/1.png',
      'title': 'Ready To travel',
      'description': 'Choose your destination, plan your trip.\nPick the best place for your holiday',
    },
    {
      'urlImage': 'assets/onboarding/2.png',
      'title': 'Select The Date',
      'description': 'Select the day.Pick your ticket.We give give you the best price.We guaranteed!',
    },
    {
      'urlImage': 'assets/onboarding/3.png',
      'title': 'Feels Like Home',
      'description': 'Enjoy your holiday! Don\'t forget to take a beer and take a photo.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      child: Column(children: [
            _buildPageRows(),
            _isLastPage ? _buildContinueRow() : _buildDotsRow(),
        ]
      ));
  }

  Widget _buildPageRows() {
    return Expanded(
      child: PageView.builder(
          controller: _pagesController,
          onPageChanged: (index) {
            setState(() => _isLastPage = index == 2);
          },
          itemCount: _pages.length,
          itemBuilder: (BuildContext context, int index) {
            return OnboardingPage(
              urlImage: _pages[index]['urlImage'],
              title: _pages[index]['title'],
              description: _pages[index]['description'],
            );
          }),
    );
  }

  Widget _buildDotsRow() {
      return Center(
        child: SmoothPageIndicator(
          controller: _pagesController,
          count: _pages.length,
          effect: const WormEffect(
            spacing: 20,
            dotColor: Colors.black26,
            activeDotColor: Colors.teal,
          ),
          //to click on dots and move
          onDotClicked: (index) =>
              _pagesController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              ),
        ),
      );
  }

  Widget _buildContinueRow() {
    return MyCTAButton(
        onPressed: () async {
          if (_isLastPage == true) {
            await widget._settingsController.updateIsOnboarded(true);
            // In some cases, we may run the onboarding while having
            // an already registered purchase.
            if (getIt<PlansController>().shouldSkipPlans()) {
              context.go('/');
            } else {
              context.go('/plans');
            }
          } else {
            await _pagesController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          }
        },
        child: const Text(
          'Continue',
          textAlign: TextAlign.center)
    );
  }
}
