import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sortmaster_photos/src/commands/settings/refresh_onboarding_command.dart';
import 'package:sortmaster_photos/src/commands/settings/update_onboarding_command.dart';
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
  late List<OnboardingData> _onboardingPages;

  bool get _isFirstPage => _selectedPage == 0;

  bool get _isLastPage => _selectedPage + 1 == _onboardingPages.length;

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
    _onboardingPages = [];
    WidgetsBinding.instance.addPostFrameCallback((_) => _initState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _onboardingPages = context.select<SettingsModel, List<OnboardingData>>(
        (value) => value.onboardingSteps);
    return MyScaffold(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildPageRows(),
      _isLastPage ? _buildValidateOnboardingRow() : _buildDotsRow(),
    ]));
  }

  Widget _buildPageRows() {
    return Expanded(
      child: PageView.builder(
          controller: _pagesController,
          onPageChanged: _updateSelectedPage,
          itemCount: _onboardingPages.length,
          itemBuilder: (BuildContext context, int index) {
            return OnboardingPage(onboardingData: _onboardingPages[index]);
          }),
    );
  }

  Widget _buildDotsRow() {
    List<Widget> children = [
      SmoothPageIndicator(
        controller: _pagesController,
        count: _onboardingPages.length,
        effect: const WormEffect(
          spacing: 20,
          dotColor: Colors.black26,
          activeDotColor: Colors.teal,
        ),
        //to click on dots and move
        onDotClicked: _onNextPressed,
      )
    ];
    if (!_isFirstPage) {
      children.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            onPressed: () => _onNextPressed(_selectedPage - 1),
            child: const Text('Back')),
        ElevatedButton(
            onPressed: () => _onNextPressed(_selectedPage + 1),
            child: const Text('Next'))
      ]));
    } else {
      children.add(ElevatedButton(
          onPressed: () => _onNextPressed(_selectedPage + 1),
          child: const Text('Next')));
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  void _onNextPressed(int index) {
    _pagesController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Widget _buildValidateOnboardingRow() {
    return ElevatedButton(
        onPressed: () async {
          await UpdateOnboardingCommand(context).run(isOnboarded: true);
          if (!context.mounted) return;
          context.go('/');
        },
        child: const Text('Continue', textAlign: TextAlign.center));
  }
}
