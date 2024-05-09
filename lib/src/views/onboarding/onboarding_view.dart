import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/settings/update_onboarding_command.dart';
import 'package:app/src/models/app_model.dart';
import 'package:app/src/views/onboarding/onboarding_item_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingView> {
  late CarouselController _controller;
  late List<OnboardingData> _pages;
  late bool _isFirstPage;
  late bool _isLastPage;

  @override
  void initState() {
    _controller = CarouselController();
    _pages = context.read<AppModel>().onboardingPages;
    _isFirstPage = true;
    _isLastPage = _pages.isNotEmpty ? false : true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> controls = [];
    // if (!_isFirstPage && !_isLastPage) {
    //   controls.add(Flexible(
    //     child: ElevatedButton(
    //       onPressed: _controller.previousPage,
    //       child: Icon(Icons.adaptive.arrow_back),
    //     ),
    //   ));
    // }
    if (!_isLastPage) {
      controls.add(Flexible(
        child: ElevatedButton(
          onPressed: _controller.nextPage,
          child: const Text('Next'),
        ),
      ));
    } else {
      controls.add(Flexible(
        child: ElevatedButton(
          onPressed: () async {
            await UpdateOnboardingCommand(context)
                .run(isOnboarded: true)
                .then((value) => {if (context.mounted) context.go('/')});
          },
          child: const Text('Continue'),
        ),
      ));
    }

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      CarouselSlider.builder(
        carouselController: _controller,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return OnboardingItemView(item: _pages[index]);
        },
        options: CarouselOptions(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.9
                : MediaQuery.of(context).size.height * 0.8,
            enlargeCenterPage: true,
            enlargeFactor: 0.5,
            enableInfiniteScroll: false,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                _isFirstPage = (index == 0);
                _isLastPage = (index + 1 == _pages.length);
              });
            }),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: controls)
    ])));
  }
}
