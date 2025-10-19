import 'dart:async';
import 'package:isar/isar.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' as pm;

class AssetLocalDataSource {
  final Isar _isar;

  final int _refreshBatchSize = 1000;
  final _types = pm.RequestType.fromTypes([
    pm.RequestType.image,
    pm.RequestType.video,
  ]);

  AssetLocalDataSource(this._isar);

  Future<List<AssetEntity>> getAllAssets() async {
    return await _isar.assetEntitys.where().findAll();
  }

  Future<AssetEntity?> getAssetById(int id) async {
    return await _isar.assetEntitys.get(id);
  }

  Future<AssetEntity?> getAssetByAssetId(String assetId) async {
    return await _isar.assetEntitys
        .filter()
        .assetIdEqualTo(assetId)
        .findFirst();
  }

  Future<List<AssetEntity>> getAssetsByYear(int year) async {
    final startDate = DateTime(year);
    final endDate = DateTime(year + 1);
    return await _isar.assetEntitys
        .filter()
        .creationDateBetween(startDate, endDate)
        .findAll();
  }

  Future<List<AssetEntity>> getAssetsByYearAndMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1);
    return await _isar.assetEntitys
        .filter()
        .creationDateBetween(startDate, endDate)
        .findAll();
  }

  Future<List<int>> addAssets(List<AssetEntity> assets) async {
    final ids = <int>[];
    await _isar.writeTxn(() async {
      for (final asset in assets) {
        final id = await _isar.assetEntitys.put(asset);
        ids.add(id);
      }
    });
    return ids;
  }

  Future<void> updateAssets(List<AssetEntity> assets) async {
    await _isar.writeTxn(() async {
      await _isar.assetEntitys.putAll(assets);
    });
  }

  Future<void> deleteAssets(List<int> ids) async {
    await _isar.writeTxn(() async {
      await _isar.assetEntitys.deleteAll(ids);
    });
  }

  Future<void> deleteAssetsByYear(int year) async {
    final assets = await getAssetsByYear(year);
    final ids = assets.map((e) => e.id).toList();
    await deleteAssets(ids);
  }

  Future<void> deleteAssetsByYearAndMonth(int year, int month) async {
    final assets = await getAssetsByYearAndMonth(year, month);
    final ids = assets.map((e) => e.id).toList();
    await deleteAssets(ids);
  }

  // Device-level operations (PhotoManager)
  Future<List<String>> deleteAssetsFromDevice({
    required List<String> assetIds,
    required bool isDry,
  }) async {
    if (assetIds.isNotEmpty) {
      if (isDry) {
        await Future.delayed(Duration(milliseconds: assetIds.length * 100));
      } else {
        await pm.PhotoManager.editor.deleteWithIds(assetIds);
      }
    }
    return assetIds;
  }

  Future<int> getDeviceAssetsCount() async {
    return await pm.PhotoManager.getAssetCount(type: _types);
  }

  Future<List<AssetEntity>> listDeviceAssets({required int year}) async {
    List<AssetEntity> assets = [];
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
        final asset = AssetEntity(
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
      await openAppSettings();
    }
  }

  Future<bool> isPhotosAuthorized() async {
    final photosStatus = await Permission.photos.status;
    return photosStatus.isGranted;
  }
}
