import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/services/assets_service.dart';
import 'package:sortmaster_photos/src/services/sessions_service.dart';
import 'package:watch_it/watch_it.dart';

class AssetsController with ChangeNotifier {

  final _assetsService = di<AssetsService>();
  final _sessionsService = di<SessionsService>();
  late int _yearMonth;
  int get yearMonth => _yearMonth;
  late List<Asset> _assetsFromMonth = [];
  late int _currentSelectionIndex = 0;
  int get currentSelectionIndex => _currentSelectionIndex;
  int get totalAssetsForMonth => _assetsFromMonth.length;

  Asset? get currentSelectionAsset => (_assetsFromMonth.isNotEmpty && _currentSelectionIndex > -1 && _currentSelectionIndex < _assetsFromMonth.length) ? _assetsFromMonth[_currentSelectionIndex] : null;

  List<Asset> get assetsToDrop => _assetsFromMonth.where((asset) => (_currentSession != null && _currentSession!.assetIdsToDrop.contains(asset.id))).toList();

  Future<void> init({required int yearMonth}) async {
    _yearMonth = yearMonth;
    _assetsFromMonth = await _assetsService.listForYearMonth(yearMonth: yearMonth);
    _currentSelectionIndex = 0;
    _currentSession = await _sessionsService.createOrRecoverSession(yearMonth: yearMonth, firstAssetId: currentSelectionAsset!.id);
    notifyListeners();
  }

  Future<void> onKeepPressed({Asset? asset, VoidCallback? onNextAvailable, VoidCallback? onEnd}) async {
    print('Keep');
    var newIndex = _currentSelectionIndex;
    if (asset == null) {
      asset = currentSelectionAsset;
      newIndex = _currentSelectionIndex+1;
    }
    if (_assetsFromMonth.length <= newIndex) {
      _currentSession?.assetIdsToDrop.remove(asset!.id);
      if (onEnd != null) onEnd();
    } else {
      _currentSession?.assetIdsToDrop.remove(asset!.id);
      if (onNextAvailable != null) onNextAvailable();
    }
    _currentSelectionIndex = newIndex;
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

  Future<void> startSession() async {
    _currentSession = await _sessionsService.createOrRecoverSession(yearMonth: yearMonth, firstAssetId: currentSelectionAsset!.id);
    print('Session: ${_currentSession?.yearMonth} ${_currentSession?.id} ${_currentSession?.currentAssetId} ${_currentSession?.assetIdsToDrop}');
    notifyListeners();
  }

  Future<void> finishSession({bool isCanceled = false}) async {
    if (_currentSession != null) {
      print('Session: ${_currentSession?.yearMonth} ${_currentSession?.id} ${_currentSession?.currentAssetId} ${_currentSession?.assetIdsToDrop}');
      await _sessionsService.finishSession(session: _currentSession!, isCanceled: isCanceled);
      _currentSession = null;
      notifyListeners();
    }
  }
}