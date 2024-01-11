import 'package:cuisine/src/onboarding/onboarding_page.dart';
import 'package:cuisine/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget{

  const OnboardingView({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State <StatefulWidget> createState () => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {

  final controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index){
            setState(() => isLastPage = index == 2);
          },
          children: const [
            OnboardingPage(
              urlImage: 'assets/onboarding/1.png',
              title: 'Ready To travel',
              subtitle: 'Choose your destination, plan your trip.\nPick the best place for your holiday',
            ),
            OnboardingPage(
              urlImage: 'assets/onboarding/2.png',
              title: 'Select The Date',
              subtitle: 'Select the day.Pick your ticket.We give give you the best price.We guaranted!',
            ),
            OnboardingPage(
              urlImage: 'assets/onboarding/3.png',
              title: 'Feels Like Home',
              subtitle: 'Enjoy your holiday! Don\'t forget to take a beer and take a photo.',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal.shade700,
          minimumSize: const Size.fromHeight(60),
        ),
        onPressed: () async {
          await widget.settingsController.updateIsOnboarded(true);
          context.go('/');
        },
        child: const Text(
          'Get Started',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          :Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            //skip
            TextButton(
                onPressed: () => controller.jumpToPage(2),
                child: const Text('SKIP', style: TextStyle(fontSize: 17,),)),
            //dots
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect:const WormEffect(
                  spacing: 20,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.teal,
                ),
                //to click on dots and move
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                ),
              ),
            ),
            //next
            TextButton(
                onPressed: () => controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,),
                child: const Text('NEXT', style: TextStyle(fontSize: 17,),)),
          ],
        ),
      ),
    );
  }
}
