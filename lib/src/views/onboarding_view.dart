import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sortmaster_photos/src/commands/settings/refresh_onboarding_command.dart';
import 'package:sortmaster_photos/src/commands/settings/update_onboarding_command.dart';
import 'package:sortmaster_photos/src/components/my_cta_button.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:sortmaster_photos/src/pages/onboarding_page.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController _pagesController;
  late int _selectedPage;

  void _updateSelectedPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  Future<void> _initState() async {
    await RefreshOnboardingCommand(context).run();
  }

  @override
  void initState() {
    _pagesController = PageController();
    _selectedPage = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<OnboardingData> onboardingPages =
        context.select<SettingsModel, List<OnboardingData>>(
            (value) => value.onboardingSteps);
    bool isLastPage =
        (_selectedPage + 1 == onboardingPages.length) ? true : false;
    return MyScaffold(
        child: Column(children: [
      _buildPageRows(onboardingPages),
      isLastPage
          ? _buildValidateOnboardingRow(context)
          : _buildDotsRow(onboardingPages),
    ]));
  }

  Widget _buildPageRows(List<OnboardingData> onboardingPages) {
    return Expanded(
      child: PageView.builder(
          controller: _pagesController,
          onPageChanged: _updateSelectedPage,
          itemCount: onboardingPages.length,
          itemBuilder: (BuildContext context, int index) {
            return OnboardingPage(onboardingData: onboardingPages[index]);
          }),
    );
  }

  Widget _buildDotsRow(List<OnboardingData> onboardingPages) {
    return Center(
      child: SmoothPageIndicator(
        controller: _pagesController,
        count: onboardingPages.length,
        effect: const WormEffect(
          spacing: 20,
          dotColor: Colors.black26,
          activeDotColor: Colors.teal,
        ),
        //to click on dots and move
        onDotClicked: (index) => _pagesController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        ),
      ),
    );
  }

  Widget _buildValidateOnboardingRow(BuildContext context) {
    return MyCTAButton(
        onPressed: () async {
          await UpdateOnboardingCommand(context).run(isOnboarded: true);
          if (!context.mounted) return;
          context.go('/');
        },
        child: const Text('Continue', textAlign: TextAlign.center));
  }
}
