import 'package:flutter/material.dart';

import 'navigation_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class NavigationView extends StatelessWidget {
  const NavigationView({super.key, required this.controller});

  static const routeName = '/nav';

  final NavigationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: this.controller.labelBehavior,
        selectedIndex: this.controller.index,
        destinations: this.controller.destinations,
        onDestinationSelected: this.controller.updateIndex,
      ),
      body: this.controller.getCurrentDestinationBody(),
    );
  }
}
