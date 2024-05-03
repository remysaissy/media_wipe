import 'dart:convert';

import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/models/abstract_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class AssetData {
  final String id;
  final DateTime creationDate;

  AssetData({required this.id, required this.creationDate});

  AssetData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        creationDate =
            DateTime.fromMillisecondsSinceEpoch(json['creationDate']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'creationDate': creationDate.millisecondsSinceEpoch};

  Future<AssetEntity?> loadEntity() async {
    return await AssetEntity.fromId(id);
  }
}

class AssetsModel extends AbstractModel {
  AssetsModel() {
    enableSerialization('assets.dat');
  }

  Map<String, List<AssetData>> _assets = {};

  Map<String, List<AssetData>> get assets => _assets;

  Map<String, Map<String, List<AssetData>>> get assetsPerYearMonth {
    Map<String, Map<String, List<AssetData>>> mapPerYear = {};
    for (var items in _assets.entries) {
      final dt = items.value.first.creationDate;
      if (!mapPerYear.containsKey(dt.year.toString())) {
        mapPerYear[dt.year.toString()] = {};
      }
      mapPerYear[dt.year.toString()]![dt.month.toString()] =
          assets.values.first;
    }
    return mapPerYear;
  }

  set assets(Map<String, List<AssetData>> assets) {
    _assets = assets;
    _updatedAt = DateTime.now();
    scheduleSave();
    notifyListeners();
  }

  // void updateAssetEntry(String key, List<AssetData> value) {
  //   _assets[key] = value;
  //   _updatedAt = DateTime.now();
  //   scheduleSave();
  //   notifyListeners();
  // }

  DateTime _updatedAt = DateTime.fromMillisecondsSinceEpoch(0);

  DateTime get updatedAt => _updatedAt;

  @override
  void reset([bool notify = true]) {
    Utils.logger.i("[AssetsModel] Reset");
    copyFromJson({});
    super.reset(notify);
  }

  /////////////////////////////////////////////////////////////////////
  // Define serialization methods

  //Json Serialization
  @override
  AssetsModel copyFromJson(Map<String, dynamic> json) {
    _assets = json.containsKey('_assets') ? jsonDecode(json['_assets']) : {};
    _updatedAt = json.containsKey('_updatedAt')
        ? DateTime.fromMillisecondsSinceEpoch(json['_updatedAt'])
        : DateTime.fromMillisecondsSinceEpoch(0);
    return this;
  }

  @override
  Map<String, dynamic> toJson() => {
        '_assets': jsonEncode(_assets),
        '_updatedAt': _updatedAt.millisecondsSinceEpoch,
      };
}
