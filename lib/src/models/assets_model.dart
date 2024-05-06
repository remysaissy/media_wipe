import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:app/src/models/abstract_model.dart';
import 'package:app/src/utils.dart';

@Entity()
class AssetData {
  final String assetId;
  final DateTime creationDate;

  AssetData({required this.assetId, required this.creationDate});

  AssetData.fromJson(Map<String, dynamic> json)
      : assetId = json['id'] as String,
        creationDate =
        DateTime.fromMillisecondsSinceEpoch(json['creationDate']);

  Map<String, dynamic> toJson() =>
      {'id': assetId, 'creationDate': creationDate.millisecondsSinceEpoch};

  Future<AssetEntity?> loadEntity() async {
    return await AssetEntity.fromId(assetId);
  }
}

class AssetsData {
  final int year;
  final int month;
  List<AssetData> assets;
  List<String> assetIdsToDrop;

  AssetsData(
      {required this.year,
      required this.month,
      required this.assets,
      required this.assetIdsToDrop});

  AssetsData.fromJson(Map<String, dynamic> json)
      : year = int.parse(json['year']),
        month = int.parse(json['month']),
        assets = jsonDecode(json['assets']),
        assetIdsToDrop = jsonDecode(json['assetIdsToDrop']);

  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'assets': jsonEncode(assets),
        'assetIdsToDrop': jsonEncode(assetIdsToDrop)
      };
}

class AssetsModel extends AbstractModel {
  AssetsModel() {
    enableSerialization('assets.dat');
  }

  List<AssetsData> _assets = [];

  List<AssetsData> get assets => _assets;

  set assets(List<AssetsData> assets) {
    _assets = assets;
    _updatedAt = DateTime.now();
    scheduleSave();
    notifyListeners();
  }

  void setAssetsAt(int index, AssetsData assets) {
    _assets[index] = assets;
    _updatedAt = DateTime.now();
    scheduleSave();
    notifyListeners();
  }

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
    _assets = json.containsKey('_assets') ? jsonDecode(json['_assets']) : [];
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
