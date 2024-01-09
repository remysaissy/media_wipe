import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  /// Loads the User's onboarding state from local storage.
  Future<bool> isOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isOnboarded') ?? false;
  }

  /// Loads the Application version when the user was onboarded from local storage.
  Future<String?> onboardedVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('onboardedVersion');
  }

  /// Persists the user's onboarding state to local storage.
  Future<void> updateOnboardingState(bool isOnboarded, String? onboardedVersion) async {
    // When onboarded is set to true, it is mandatory to provide the version.
    if (isOnboarded == true && onboardedVersion == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboarded', isOnboarded);
    if (isOnboarded == true) {
      await prefs.setString('onboardedVersion', onboardedVersion!);
    } else {
      await prefs.remove('onboardedVersion');
    }
  }
}
