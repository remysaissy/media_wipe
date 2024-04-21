import 'package:flutter/material.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


  // final _onboardingController = di<OnboardingController>();
  //
  // OnboardingView({super.key});
  //
  // @override
  // Widget build(BuildContext context) {
  //   final isLastPage = watchPropertyValue((OnboardingController x) => x.isLastPage);
  //   return MyScaffold(
  //     child: Column(children: [
  //           _buildPageRows(),
  //       isLastPage ? _buildValidateOnboardingRow(context) : _buildDotsRow(),
  //       ]
  //     ));
  // }
  //
  // Widget _buildPageRows() {
  //   return Expanded(
  //     child: PageView.builder(
  //         controller: _onboardingController.pagesController,
  //         onPageChanged: _onboardingController.updateSelectedPage,
  //         itemCount: _onboardingController.pages.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return OnboardingPage(
  //             urlImage: _onboardingController.pages[index]['urlImage'],
  //             title: _onboardingController.pages[index]['title'],
  //             description: _onboardingController.pages[index]['description'],
  //           );
  //         }),
  //   );
  // }
  //
  // Widget _buildDotsRow() {
  //     return Center(
  //       child: SmoothPageIndicator(
  //         controller: _onboardingController.pagesController,
  //         count: _onboardingController.pages.length,
  //         effect: const WormEffect(
  //           spacing: 20,
  //           dotColor: Colors.black26,
  //           activeDotColor: Colors.teal,
  //         ),
  //         //to click on dots and move
  //         onDotClicked: (index) =>
  //             _onboardingController.pagesController.animateToPage(
  //               index,
  //               duration: const Duration(milliseconds: 500),
  //               curve: Curves.ease,
  //             ),
  //       ),
  //     );
  // }
  //
  // Widget _buildValidateOnboardingRow(BuildContext context) {
  //   return MyCTAButton(
  //       onPressed: () async {
  //           await _onboardingController.validateOnboarding();
  //           if (!context.mounted) return;
  //           context.go('/plans');
  //       },
  //       child: const Text(
  //         'Continue',
  //         textAlign: TextAlign.center)
  //   );
  // }
}
