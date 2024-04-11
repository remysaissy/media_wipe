import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/components/my_cta_button.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_controller.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:watch_it/watch_it.dart';

class OnboardingView extends StatelessWidget with WatchItMixin {

  OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = di<OnboardingController>();
    final isLastPage = watchPropertyValue((OnboardingController x) => x.isLastPage);
    return MyScaffold(
      child: Column(children: [
            _buildPageRows(controller),
        isLastPage ? _buildValidateOnboardingRow(context, controller) : _buildDotsRow(controller),
        ]
      ));
  }

  Widget _buildPageRows(OnboardingController controller) {
    return Expanded(
      child: PageView.builder(
          controller: controller.pagesController,
          onPageChanged: controller.updateSelectedPage,
          itemCount: controller.pages.length,
          itemBuilder: (BuildContext context, int index) {
            return OnboardingPage(
              urlImage: controller.pages[index]['urlImage'],
              title: controller.pages[index]['title'],
              description: controller.pages[index]['description'],
            );
          }),
    );
  }

  Widget _buildDotsRow(OnboardingController controller) {
      return Center(
        child: SmoothPageIndicator(
          controller: controller.pagesController,
          count: controller.pages.length,
          effect: const WormEffect(
            spacing: 20,
            dotColor: Colors.black26,
            activeDotColor: Colors.teal,
          ),
          //to click on dots and move
          onDotClicked: (index) =>
              controller.pagesController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              ),
        ),
      );
  }

  Widget _buildValidateOnboardingRow(BuildContext context, OnboardingController controller) {
    return MyCTAButton(
        onPressed: () async {
            await controller.validateOnboarding();
            if (!context.mounted) return;
            context.go('/plans');
        },
        child: const Text(
          'Continue',
          textAlign: TextAlign.center)
    );
  }
}
