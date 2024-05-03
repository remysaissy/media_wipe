import 'dart:async';
import 'package:exif/exif.dart';
import 'package:photo_manager/photo_manager.dart' as pm;
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class AssetsService {
  final int _refreshBatchSize = 100;
  final _types = pm.RequestType.fromTypes([pm.RequestType.image]);

  Future<void> deleteAssetsPerId(List<String> assetIds) async {
    if (assetIds.isNotEmpty) {
      Utils.logger.i('Drop all IDs: ${assetIds}');
      // await PhotoManager.editor.deleteWithIds(sessionData.assetIdsToDrop);
    }
  }

  Future<Map<String, List<AssetData>>> listAssets({int? year}) async {
    Map<String, List<AssetData>> assets = {};
    if (year != null) {
      assets = await _listAssetsFromYear(year);
    } else {
      assets = await _listAllAssets();
    }
    return assets;
  }

  Future<Map<String, List<AssetData>>> _listAllAssets() async {
    Map<String, List<AssetData>> assets = {};
    final count = await pm.PhotoManager.getAssetCount(type: _types);
    for (int index = 0; index < count; index += _refreshBatchSize) {
      final assetsEntities = await pm.PhotoManager.getAssetListRange(
          start: index, end: index + _refreshBatchSize, type: _types);
      for (pm.AssetEntity assetEntity in assetsEntities) {
        final asset = await _createAssetData(assetEntity);
        final yearMonth = Utils.stringifyYearMonth(
            year: asset.creationDate.year, month: asset.creationDate.month);
        if (assets.containsKey(yearMonth)) {
          assets[yearMonth]?.add(asset);
        } else {
          assets[yearMonth] = [asset];
        }
      }
    }
    return assets;
  }

  Future<Map<String, List<AssetData>>> _listAssetsFromYear(int year) async {
    Map<String, List<AssetData>> assets = {};
    var filter = pm.AdvancedCustomFilter()
      ..addWhereCondition(
          pm.DateColumnWhereCondition(
            column: pm.CustomColumns.base.createDate,
            operator: '>=',
            value: DateTime(year),
          ),
          type: pm.LogicalType.and)
      ..addWhereCondition(
          pm.DateColumnWhereCondition(
            column: pm.CustomColumns.base.createDate,
            operator: '<',
            value: DateTime(year + 1),
          ),
          type: pm.LogicalType.and)
      ..addOrderBy(column: pm.CustomColumns.base.createDate, isAsc: false);
    final count =
        await pm.PhotoManager.getAssetCount(type: _types, filterOption: filter);
    for (int index = 0; index < count; index += _refreshBatchSize) {
      final assetsEntities = await pm.PhotoManager.getAssetListRange(
          start: index,
          end: index + _refreshBatchSize,
          type: _types,
          filterOption: filter);
      for (pm.AssetEntity assetEntity in assetsEntities) {
        final asset = await _createAssetData(assetEntity);
        final yearMonth = Utils.stringifyYearMonth(
            year: asset.creationDate.year, month: asset.creationDate.month);
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
      creationDate = Utils.creationDateFormat
          .parse(exifData['EXIF DateTimeOriginal'].toString());
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
