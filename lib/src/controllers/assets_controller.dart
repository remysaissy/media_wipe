import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/services/assets_service.dart';
import 'package:watch_it/watch_it.dart';

class AssetsController with ChangeNotifier {

  final _assetsService = di<AssetsService>();
  late List<Asset> _assetsFromMonth = [];
  late int _currentSelectionIndex = 0;
  int get currentSelectionIndex => _currentSelectionIndex;
  int get totalAssetsForMonth => _assetsFromMonth.length;

  Asset? get currentSelectionAsset => (_assetsFromMonth.isNotEmpty && _currentSelectionIndex > -1 && _currentSelectionIndex < _assetsFromMonth.length) ? _assetsFromMonth[_currentSelectionIndex] : null;
  bool get isCurrentMonthFinished => (_assetsFromMonth.length == _currentSelectionIndex) ? true : false;

  Future<void> loadWithYearMonth(int year, int month) async {
    _assetsFromMonth = await _assetsService.listForYearMonth(year: year, month: month);
    _currentSelectionIndex = 0;
    notifyListeners();
  }

  Future<void> onKeepPressed({VoidCallback? onNextAvailable, VoidCallback? onEnd}) async {
    print('Keep');
    if (_assetsFromMonth.length == _currentSelectionIndex+1) {
      if (onEnd != null) onEnd();
    } else {
      if (onNextAvailable != null) onNextAvailable();
    }
    _currentSelectionIndex = _currentSelectionIndex+1;
    notifyListeners();
  }

  Future<void> onDropPressed({VoidCallback? onNextAvailable, VoidCallback? onEnd}) async {
    print('Drop');
    if (_assetsFromMonth.length == _currentSelectionIndex+1) {
      if (onEnd != null) onEnd();
    } else {
      if (onNextAvailable != null) onNextAvailable();
    }
    _currentSelectionIndex = _currentSelectionIndex+1;
    notifyListeners();
  }

  Future<void> onInfoPressed() async {
    print('Info');
  }

  Future<void> onRestart() async {
    print('Restart');
    _currentSelectionIndex = 0;
    notifyListeners();
  }
}