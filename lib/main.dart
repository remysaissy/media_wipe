import 'package:cuisine/src/navigation/navigation_controller.dart';
import 'package:cuisine/src/navigation/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Use Firebase Emulators
  if (kDebugMode) { // Only for debug mode.
    try {
      FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
      // FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
      // FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // FIXME: Forcibly disable onboarding for development purpose.
  await settingsController.updateIsOnboarded(true);

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
