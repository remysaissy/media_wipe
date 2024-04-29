import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/settings/purchase_subscription_command.dart';
import 'package:sortmaster_photos/src/commands/settings/restore_subscription_command.dart';
import 'package:sortmaster_photos/src/components/my_cta_button.dart';
import 'package:sortmaster_photos/src/components/my_cta_text_button.dart';
import 'package:sortmaster_photos/src/components/my_launch_url.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:sortmaster_photos/src/views/subscriptions_item_view.dart';

class SubscriptionsView extends StatefulWidget {
  const SubscriptionsView({super.key});

  @override
  State<StatefulWidget> createState() => _SubscriptionsViewState();
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  late List<SubscriptionData> _subscriptionPlans;
  late CarouselController _controller;
  late int _selectedPlanIndex;

  @override
  void initState() {
    _selectedPlanIndex = 0;
    _controller = CarouselController();
    _subscriptionPlans = context.read<SettingsModel>().subscriptionPlans;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> controls = [];
    controls.add(Flexible(
        child: MyCTAButton(
            onPressed: () async {
              if (!context.mounted) return;
              await PurchaseSubscriptionCommand(context).run(
                  productId: _subscriptionPlans[_selectedPlanIndex].productId);
              if (!context.mounted) return;
              context.go('/');
            },
            child: const Text('Purchase', textAlign: TextAlign.center))));
    controls.add(Flexible(
        child: MyCTATextButton(
            onPressed: () async {
              const targetURL = 'https://www.app-privacy-policy.com/';
              await myLaunchURL(context, targetURL);
            },
            text: 'Terms of use')));
    return Scaffold(
      appBar: AppBar(
        actions: [
          MyCTATextButton(
              onPressed: () async {
                await RestoreSubscriptionCommand(context).run();
                if (!context.mounted) return;
                context.go('/');
              },
              text: 'Already purchased?')
        ],
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        CarouselSlider(
          options: CarouselOptions(autoPlay: true),
          items: [
            'assets/subscriptions/1.png',
            'assets/subscriptions/2.png',
            'assets/subscriptions/3.png'
          ]
              .map(
                (item) => Center(child: Image.asset(item)),
              )
              .toList(),
        ),
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: _subscriptionPlans.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return SubscriptionItemView(item: _subscriptionPlans[index]);
          },
          options: CarouselOptions(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.45
                  : MediaQuery.of(context).size.height * 0.45,
              enlargeCenterPage: true,
              enlargeFactor: 0.5,
              enableInfiniteScroll: false,
              autoPlay: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _selectedPlanIndex = index;
                });
              }),
        ),
        ElevatedButton(
            onPressed: () async {
              if (!context.mounted) return;
              await PurchaseSubscriptionCommand(context).run(
                  productId: _subscriptionPlans[_selectedPlanIndex].productId);
              if (!context.mounted) return;
              context.go('/');
            },
            child: Text('Purchase',
                style: Theme.of(context).textTheme.bodyMedium)),
        TextButton(
            onPressed: () async {
              const targetURL = 'https://www.app-privacy-policy.com/';
              await myLaunchURL(context, targetURL);
            },
            child: Text('Terms of use',
                style: Theme.of(context).textTheme.bodySmall))
        // Column(
        //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: controls)
      ])),
    );
  }
}
