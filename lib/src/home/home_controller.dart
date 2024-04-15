import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/home/assets_service.dart';
import 'package:watch_it/watch_it.dart';

class HomeController with ChangeNotifier {

  late List<DateTime> _yearMonths = [];
  List<DateTime> get yearMonths => _yearMonths;

  Future<void> refresh() async {
    final service = di<AssetsService>();
    await service.refresh();
    _yearMonths = await service.listYearMonthAssets() ?? [];
    notifyListeners();
  }

  Future<void> onYearMonthTapped(int index) async {

  }
}