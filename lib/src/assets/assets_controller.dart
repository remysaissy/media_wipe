import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/assets/assets_model.dart';
import 'package:sortmaster_photos/src/assets/assets_service.dart';
import 'package:watch_it/watch_it.dart';

class AssetsController with ChangeNotifier {

  final _assetsService = di<AssetsService>();
  late List<AssetModel> _photoFromMonth;
  List<AssetModel> get photoFromMonth => _photoFromMonth;

  Future<void> loadWithYearMonth(int year, int month) async {
    _photoFromMonth = await _assetsService.listAssetsByYearMonth(year, month) ?? [];
    notifyListeners();
  }
}