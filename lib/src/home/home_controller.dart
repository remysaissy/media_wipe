import 'package:flutter/material.dart';

class HomeController with ChangeNotifier {

  Future<void> load() async {
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}