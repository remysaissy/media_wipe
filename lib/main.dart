import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/app.dart';
import 'package:sortmaster_photos/src/ioc.dart';
import 'package:sortmaster_photos/src/plans/plans_controller.dart';
import 'package:sortmaster_photos/src/plans/plans_service.dart';
import 'package:sortmaster_photos/src/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  setup();

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await getIt<SettingsController>().load();
  await getIt<PlansController>().load();

  if (kDebugMode == true) {
    await getIt<SettingsController>().updateIsOnboarded(false);
    // await getIt<PlansService>().cancelPurchasedProductID();
  }

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp());
}
