import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/components/my_cta_button.dart';
import 'package:sortmaster_photos/src/components/my_cta_text_button.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/components/my_toggle_button.dart';
import 'package:sortmaster_photos/src/ioc.dart';
import 'package:sortmaster_photos/src/plans/plans_controller.dart';

class PlansView extends StatelessWidget {

  PlansView({super.key});

  final PlansController _controller = getIt<PlansController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child)
    {
      List<Widget> children = _buildHeader();
      children.addAll(_buildPlans(context));
      children.add(const Spacer());
      children.addAll(_buildCTA(context));
      return MyScaffold(
          appBar: AppBar(
            actions: [
              MyCTATextButton(onPressed: () async {
                await _controller.restorePurchase();
                context.go('/');
              },
                  text: 'Already purchased?')
            ],
          ),
          child: Column(
            children: children
          )
      );
    });
  }

  List<Widget> _buildCTA(BuildContext context) {
    return [
          MyCTAButton(
            onPressed: () async {
              await _controller.purchasePlan();
              context.go('/');
            },
            child: const Text('Continue',
            textAlign: TextAlign.center),
          ),
          MyCTATextButton(onPressed: () {
            print("Terms of use");
          },
          text: 'Terms of use'),
    ];
  }

  List<Widget> _buildPlans(BuildContext context) {
    double w = MediaQuery.of(context).size.width / (_controller.planLabels.length + 1);
    return [
            MyToggleButton(
                onPressed: _controller.updateSelectedPlan,
                options: _controller.planLabels,
                defaultOption: _controller.selectedPlanLabel),
            ListTile(title: Text('${_controller.plans[_controller.selectedPlan]['title']}'),
                trailing: Text('${_controller.plans[_controller.selectedPlan]['price']}'),),
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