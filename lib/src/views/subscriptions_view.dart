import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/settings/refresh_subscriptions_command.dart';
import 'package:sortmaster_photos/src/commands/settings/purchase_subscription_command.dart';
import 'package:sortmaster_photos/src/commands/settings/restore_subscription_command.dart';
import 'package:sortmaster_photos/src/components/my_cta_button.dart';
import 'package:sortmaster_photos/src/components/my_cta_text_button.dart';
import 'package:sortmaster_photos/src/components/my_launch_url.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/components/my_toggle_button.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';

class SubscriptionsView extends StatefulWidget {
  const SubscriptionsView({super.key});

  @override
  State<StatefulWidget> createState() => _SubscriptionsViewState();
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  late int _selectedPlanIndex;

  void _onPlanSelected(int index) {
    setState(() {
      _selectedPlanIndex = index;
    });
  }

  Future<void> _initState() async {
    await RefreshSubscriptionsCommand(context).run();
  }

  @override
  void initState() {
    _selectedPlanIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<SubscriptionData> subscriptionPlans =
        context.select<SettingsModel, List<SubscriptionData>>(
            (value) => value.subscriptionPlans);
    List<Widget> children = _buildHeader();
    if (subscriptionPlans.isNotEmpty) {
      children.addAll(_buildPlans(context, subscriptionPlans));
      children.add(const Spacer());
      children.addAll(_buildCTA(context, subscriptionPlans));
    }
    return MyScaffold(
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
        child: Column(children: children));
  }

  List<Widget> _buildCTA(
      BuildContext context, List<SubscriptionData> subscriptionPlans) {
    return [
      MyCTAButton(
        onPressed: () async {
          if (!context.mounted) return;
          await PurchaseSubscriptionCommand(context)
              .run(productId: subscriptionPlans[_selectedPlanIndex].productId);
          if (!context.mounted) return;
          context.go('/');
        },
        child: const Text('Continue', textAlign: TextAlign.center),
      ),
      MyCTATextButton(
          onPressed: () async {
            const targetURL = 'https://www.app-privacy-policy.com/';
            await myLaunchURL(context, targetURL);
          },
          text: 'Terms of use'),
    ];
  }

  List<Widget> _buildPlans(
      BuildContext context, List<SubscriptionData> subscriptionPlans) {
    return [
      MyToggleButton(
          onPressed: _onPlanSelected,
          options: subscriptionPlans.map((e) => e.name).toList(),
          defaultOption: _selectedPlanIndex),
      ListTile(
          title: Text(subscriptionPlans[_selectedPlanIndex].title),
          trailing: Text(subscriptionPlans[_selectedPlanIndex].price)),
    ];
  }

  List<Widget> _buildHeader() {
    return [
      Padding(
          padding: const EdgeInsets.all(50),
          child: Image.asset(
            'assets/onboarding/1.png',
          ))
    ];
  }
}
