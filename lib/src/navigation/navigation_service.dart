import 'package:flutter/material.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class NavigationService {
  /// Loads the User's preferred navigation index from local or remote storage.
  Future<int> index() async => 0;

  /// Persists the user's preferred index to local or remote storage.
  Future<void> updateIndex(int index) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }
}
