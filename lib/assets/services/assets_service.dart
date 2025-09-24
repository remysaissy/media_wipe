import 'dart:async';
import 'package:app/assets/models/asset.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' as pm;
import 'package:photo_manager/photo_manager.dart';

class AssetsService {
  final int _refreshBatchSize = 1000;
  final _types = pm.RequestType.fromTypes([
    pm.RequestType.image,
    pm.RequestType.video,
  ]);

  Future<List<String>> deleteAssetsPerId({
    required List<String> assetIds,
    required bool isDry,
  }) async {
    if (assetIds.isNotEmpty) {
      if (isDry) {
        await Future.delayed(Duration(milliseconds: assetIds.length * 100));
      } else {
        await PhotoManager.editor.deleteWithIds(assetIds);
      }
    }
    return assetIds;
  }

  Future<int> getAssetsCount() async {
    return await pm.PhotoManager.getAssetCount(type: _types);
  }

  Future<List<Asset>> listAssets({required int year}) async {
    List<Asset> assets = [];
    var filter = pm.AdvancedCustomFilter()
      ..addWhereCondition(
        pm.DateColumnWhereCondition(
          column: pm.CustomColumns.base.createDate,
          operator: '>=',
          value: DateTime(year),
        ),
        type: pm.LogicalType.and,
      )
      ..addWhereCondition(
        pm.DateColumnWhereCondition(
          column: pm.CustomColumns.base.createDate,
          operator: '<',
          value: DateTime(year + 1),
        ),
        type: pm.LogicalType.and,
      )
      ..addOrderBy(column: pm.CustomColumns.base.createDate, isAsc: false);
    final count = await pm.PhotoManager.getAssetCount(
      type: _types,
      filterOption: filter,
    );
    for (int index = 0; index < count; index += _refreshBatchSize) {
      final assetsEntities = await pm.PhotoManager.getAssetListRange(
        start: index,
        end: index + _refreshBatchSize,
        type: _types,
        filterOption: filter,
      );
      for (pm.AssetEntity assetEntity in assetsEntities) {
        final asset = Asset(
          assetId: assetEntity.id,
          creationDate: assetEntity.createDateTime,
        );
        assets.add(asset);
      }
    }
    return assets;
  }

  Future<void> authorizePhotos() async {
    final photosStatus = await Permission.photos.status;
    if (photosStatus.isDenied) {
      await Permission.photos.request();
    } else if (!photosStatus.isGranted) {
      openAppSettings();
    }
  }

  Future<bool> isPhotosAuthorized() async {
    final photosStatus = await Permission.photos.status;
    return photosStatus.isGranted;
  }
}
