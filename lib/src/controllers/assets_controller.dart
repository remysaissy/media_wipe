import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/services/assets_service.dart';
import 'package:sortmaster_photos/src/services/sessions_service.dart';
import 'package:watch_it/watch_it.dart';

class AssetsController with ChangeNotifier {

  final _assetsService = di<AssetsService>();
  final _sessionsService = di<SessionsService>();
  late List<Asset> _assetsFromMonth = [];
  late int _currentSelectionIndex = 0;
  int get currentSelectionIndex => _currentSelectionIndex;
  int get totalAssetsForMonth => _assetsFromMonth.length;

  Asset? get currentSelectionAsset => (_assetsFromMonth.isNotEmpty && _currentSelectionIndex > -1 && _currentSelectionIndex < _assetsFromMonth.length) ? _assetsFromMonth[_currentSelectionIndex] : null;
  bool get isCurrentMonthFinished => (_assetsFromMonth.length == _currentSelectionIndex) ? true : false;

  Future<void> loadWithYearMonth({required int year, required int month}) async {
    _assetsFromMonth = await _assetsService.listForYearMonth(year: year, month: month);
    _currentSelectionIndex = 0;
    notifyListeners();
  }

  Future<void> onKeepPressed({VoidCallback? onNextAvailable, VoidCallback? onEnd}) async {
    print('Keep');
    if (_assetsFromMonth.length == _currentSelectionIndex+1) {
      _currentSession?.assetIdsToDrop.remove(currentSelectionAsset!.id);
      if (onEnd != null) onEnd();
    } else {
      _currentSession?.assetIdsToDrop.remove(currentSelectionAsset!.id);
      if (onNextAvailable != null) onNextAvailable();
    }
    _currentSelectionIndex = _currentSelectionIndex+1;
    notifyListeners();
  }

  Future<void> onDropPressed({VoidCallback? onNextAvailable, VoidCallback? onEnd}) async {
    print('Drop');
    if (_assetsFromMonth.length == _currentSelectionIndex+1) {
      _currentSession?.assetIdsToDrop.add(currentSelectionAsset!.id);
      _currentSession?.currentAssetId = null;
      await _sessionsService.updateSession(session: _currentSession!);
      if (onEnd != null) onEnd();
    } else {
      _currentSession?.assetIdsToDrop.add(currentSelectionAsset!.id);
      _currentSession?.currentAssetId = _assetsFromMonth[_currentSelectionIndex+1].id;
      await _sessionsService.updateSession(session: _currentSession!);
      if (onNextAvailable != null) onNextAvailable();
    }
    _currentSelectionIndex = _currentSelectionIndex+1;
    notifyListeners();
  }

  Future<void> onInfoPressed() async {
    print('Info');
  }

  Future<void> onRestart() async {
    _currentSelectionIndex = 0;
    _currentSession?.assetIdsToDrop = [];
    _currentSession?.currentAssetId = currentSelectionAsset!.id;
    await _sessionsService.updateSession(session: _currentSession!);
    notifyListeners();
  }

  late Session? _currentSession;
  Session? get currentSession => _currentSession;

  Future<void> startSession({required int year, required int month}) async {
    _currentSession = await _sessionsService.createOrRecoverSession(year: year, month: month, firstAssetId: currentSelectionAsset!.id);
    notifyListeners();
  }

  Future<void> finishSession() async {
    if (_currentSession != null) {
      await _sessionsService.finishSession(session: _currentSession!);
      _currentSession = null;
      notifyListeners();
    }
  }
}