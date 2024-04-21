// import 'package:flutter/material.dart';
// import 'package:sortmaster_photos/src/services/assets_service.dart';
// import 'package:watch_it/watch_it.dart';
//
// class HomeController with ChangeNotifier {
//
//   final _assetsService = di<AssetsService>();
//   late List<DateTime> _yearMonths = [];
//   List<DateTime> get yearMonths => _yearMonths;
//
//   Future<void> refresh() async {
//     await _assetsService.refresh(onProgress: () async {
//       _yearMonths = await _assetsService.listAvailableYearMonths();
//       notifyListeners();
//     });
//     _yearMonths = await _assetsService.listAvailableYearMonths();
//     notifyListeners();
//   }
// }