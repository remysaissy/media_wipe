import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/components/my_cta_button.dart';
import 'package:sortmaster_photos/src/components/my_cta_text_button.dart';
import 'package:sortmaster_photos/src/components/my_launch_url.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/components/my_toggle_button.dart';
import 'package:sortmaster_photos/src/plans/plans_controller.dart';
import 'package:watch_it/watch_it.dart';

class PlansView extends StatelessWidget with WatchItMixin {

  PlansView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = di<PlansController>();
    List<Widget> children = _buildHeader();
    children.addAll(_buildPlans(context, controller));
    children.add(const Spacer());
    children.addAll(_buildCTA(context, controller));
    return MyScaffold(
        appBar: AppBar(
          actions: [
            MyCTATextButton(onPressed: () async {
              await controller.restorePurchase();
              if (!context.mounted) return;
              context.go('/home');
            },
                text: 'Already purchased?')
          ],
        ),
        child: Column(
          children: children
        )
    );
  }

  List<Widget> _buildCTA(BuildContext context, PlansController controller) {
    return [
          MyCTAButton(
            onPressed: () async {
              await controller.purchasePlan();
              if (!context.mounted) return;
              context.go('/home');
            },
            child: const Text('Continue',
            textAlign: TextAlign.center),
          ),
          MyCTATextButton(onPressed: () async {
            const targetURL = 'https://www.app-privacy-policy.com/';
            await myLaunchURL(context, targetURL);
            },
          text: 'Terms of use'),
    ];
  }

  List<Widget> _buildPlans(BuildContext context, PlansController controller) {
    final selectedPlanDescription = watchPropertyValue((PlansController x) => x.selectedPlanDescription);
    return [
            MyToggleButton(
                onPressed: controller.updateSelectedPlan,
                options: controller.planNames,
                defaultOption: controller.selectedPlan),
            ListTile(title: Text('${selectedPlanDescription['title']}'),
                trailing: Text('${selectedPlanDescription['price']}'),),
        ];
  }

  List<Widget> _buildHeader() {
    return [
        Padding(padding: const EdgeInsets.all(50),
        child: Image.asset(
          'assets/onboarding/1.png',
        ))
      ];
  }
}