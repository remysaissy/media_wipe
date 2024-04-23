import 'dart:async';
import 'package:exif/exif.dart';
import 'package:photo_manager/photo_manager.dart' as pm;
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class AssetsService {

  final int _refreshBatchSize = 100;

  Future<void> deleteAssetsPerId(List<String> assetIds) async {
    if (assetIds.isNotEmpty) {
      Utils.logger.i('Drop all IDs: ${assetIds}');
      // await PhotoManager.editor.deleteWithIds(sessionData.assetIdsToDrop);
    }
  }

  Future<Map<String, List<AssetData>>> listAssetsPerYearMonth() async {
    Map<String, List<AssetData>> assets = {};
    final type = pm.RequestType.fromTypes([pm.RequestType.image]);
    final count = await pm.PhotoManager.getAssetCount(type: type);
    for (int index = 0; index < count; index += _refreshBatchSize) {
      final assetsEntities = await pm.PhotoManager.getAssetListRange(start: index, end: index + _refreshBatchSize, type: type);
      for (pm.AssetEntity assetEntity in assetsEntities) {
          final asset = await _createAssetData(assetEntity);
          final yearMonth = Utils.stringifyYearMonth(year: asset.creationDate.year, month: asset.creationDate.month);
          if (assets.containsKey(yearMonth)) {
            assets[yearMonth]?.add(asset);
          } else {
            assets[yearMonth] = [asset];
          }
      }
    }
    return assets;
  }

  Future<AssetData> _createAssetData(pm.AssetEntity element) async {
    final exifData = await _extractMetadata(element);
    DateTime creationDate = element.createDateTime;
    if (exifData.containsKey('EXIF DateTimeOriginal')) {
      creationDate = Utils.creationDateFormat.parse(exifData['EXIF DateTimeOriginal'].toString());
    }
    return AssetData(id: element.id, creationDate: creationDate);
  }

  Future<Map<String, IfdTag>> _extractMetadata(pm.AssetEntity element) async {
    final bytes = await element.originBytes;
    if (bytes == null) {
      return {};
    }
    return await readExifFromBytes(bytes);
  }
}