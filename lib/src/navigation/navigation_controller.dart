import 'package:app/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';

import '../sample_feature/sample_item_list_view.dart';
import 'navigation_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class NavigationController with ChangeNotifier {
  NavigationController(this._navigationService, this._settingsController);

  // Make NavigationService a private variable so it is not used directly.
  final NavigationService _navigationService;

  // Make SettingsController a private variable so it is not used directly.
  final SettingsController _settingsController;

  // Make index a private variable so it is not updated directly without
  // also persisting the changes with the NavigationService.
  late int _index;

  // Allow Widgets to read the user's preferred index.
  int get index => _index;

  // Make labelBehavior a private variable so it is not updated directly without
  // also persisting the changes with the NavigationService.
  late NavigationDestinationLabelBehavior _labelBehavior;

  // Allow Widgets to read the user's preferred NavigationDestinationLabelBehavior.
  NavigationDestinationLabelBehavior get labelBehavior => NavigationDestinationLabelBehavior.alwaysShow;

  // Make destinations a private variable so it is not updated directly without
  // also persisting the changes with the NavigationService.
  late List<Widget> _destinations;

  // Allow Widgets to read the user's preferred destinations.
  List<Widget> get destinations => [
    const NavigationDestination(
      icon: Icon(Icons.explore),
      label: 'Explore',
    ),
    const NavigationDestination(
      icon: Icon(Icons.commute),
      label: 'Commute',
    ),
    const NavigationDestination(
      selectedIcon: Icon(Icons.bookmark),
      icon: Icon(Icons.bookmark_border),
      label: 'Saved',
    ),
  ];

  // Allow Widgets to read the user's preferred destinationBodies.
  Widget getCurrentDestinationBody() {
    return const SampleItemListView();
  }

  /// Load the user's settings from the NavigationService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _index = await _navigationService.index();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateIndex(int? newIndex) async {
    if (newIndex == null) return;

    // Do not perform any work if new and old index are identical
    if (newIndex == _index) return;

    // Otherwise, store the new index in memory
    _index = newIndex;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // NavigationService.
    await _navigationService.updateIndex(newIndex);
  }
}
