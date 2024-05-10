import 'package:app/src/models/asset.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:objectbox/objectbox.dart';

class AssetsModel extends ChangeNotifier {
  final Box<Asset> _assetsBox;

  AssetsModel(this._assetsBox);

  List<Asset> _assets = [];

  /// Use for initial loading.
  Future<AssetsModel> load() async {
    await fetchAssets();
    return this;
  }

  /// Pivotal method to fetch the up to date list of assets from storage.
  Future<void> fetchAssets() async {
    _assets = await _assetsBox.getAllAsync();
    notifyListeners();
  }

  Asset? getAsset({int? id, String? assetId}) {
    return _assets
        .where((e) =>
            (id == null || e.id == id) &&
            (assetId == null || e.assetId == assetId))
        .firstOrNull;
  }

  List<int> listYears({bool isAsc = false}) {
    var years = _assets.map((e) => e.creationDate.year).toSet().toList();
    years.sort((a, b) => isAsc ? a.compareTo(b) : b.compareTo(a));
    return years;
  }

  List<int> listAssetsMonths({required int forYear, bool isAsc = false}) {
    var months = listAssets(forYear: forYear)
        .map((e) => e.creationDate.month)
        .toSet()
        .toList();
    months.sort((a, b) => isAsc ? a.compareTo(b) : b.compareTo(a));
    return months;
  }

  List<Asset> listAssets(
      {int? forYear, int? butYear, int? forMonth, List<Asset>? withAllowList}) {
    return _assets
        .where((e) =>
            (forYear == null || e.creationDate.year == forYear) &&
            (forMonth == null || e.creationDate.month == forMonth) &&
            (withAllowList == null || withAllowList.contains(e)))
        .toList();
  }

  Future<void> updateAssets({required List<Asset> assets}) async {
    if (assets.isNotEmpty) {
      await _assetsBox.putManyAsync(assets, mode: PutMode.update);
      await fetchAssets();
    }
  }

  Future<void> removeAssets({int? forYear, int? forMonth}) async {
    final ids = _assets
        .where((e) =>
            (forYear == null || e.creationDate.year == forYear) &&
            (forMonth == null || e.creationDate.month == forMonth))
        .map((e) => e.id)
        .toList();
    if (ids.isNotEmpty) {
      await _assetsBox.removeManyAsync(ids);
      await fetchAssets();
    }
  }

  Future<void> removeAssetsFromList({required List<int> ids}) async {
    if (ids.isNotEmpty) {
      await _assetsBox.removeManyAsync(ids);
      await fetchAssets();
    }
  }

  Future<List<int>> addAssets({required List<Asset> assets}) async {
    final ids = await _assetsBox.putManyAsync(assets, mode: PutMode.insert);
    if (ids.isNotEmpty) {
      await fetchAssets();
    }
    return ids;
  }
}
