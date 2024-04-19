import 'dart:async';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart' as pm;
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/services/db_service.dart';
import 'package:sortmaster_photos/src/utils.dart';
import 'package:watch_it/watch_it.dart';

class AssetsService {

  final int _REFRESH_BATCH_SIZE = 100;
  late DBService _dbService;

  Future<AssetsService> init() async {
    _dbService = di<DBService>();
    return this;
  }

  Future<void> refresh({VoidCallback? onProgress}) async {
    final dbPersistedAssets = await _list();
    final List<String> newlyPersistedIDs = [];

    final type = pm.RequestType.fromTypes([pm.RequestType.image, pm.RequestType.video]);
    final count = await pm.PhotoManager.getAssetCount(type: type);

    for (int index = 0; index < count; index += _REFRESH_BATCH_SIZE) {
      final assetsEntities = await pm.PhotoManager.getAssetListRange(start: index, end: index + _REFRESH_BATCH_SIZE, type: type);
      for (pm.AssetEntity assetEntity in assetsEntities) {
        if (!dbPersistedAssets.containsKey(assetEntity.id)) {
          final asset = await _createAssetModel(assetEntity);
          await _create(asset);
          newlyPersistedIDs.add(asset.id);
        }
      }
      // Provide progress feedback for very large libraries.
      if (onProgress != null) {
        onProgress();
      }
    }
    // Remove assets that have been removed from the device since last refresh.
    // Calculate IDs stored on DB that were not retrieved at all and remove it from DB.
    final dbPersistedIDs = dbPersistedAssets.keys.toSet();
    final toRemoveIDs = dbPersistedIDs.difference(newlyPersistedIDs.toSet()); //.difference(alreadyPersistedIDs.toSet());
    await _deleteAll(toRemoveIDs);
  }

  Future<List<DateTime>> listAvailableYearMonths() async {
    return await _listAvailableYearMonths();
  }

  Future<List<Asset>> listForYearMonth({required int yearMonth}) async {
    return await _listForYearMonth(yearMonth: yearMonth);
  }

  Future<Asset> _createAssetModel(pm.AssetEntity element) async {
    final exifData = await _extractMetadata(element);
    DateTime creationDate = element.createDateTime;
    if (exifData.containsKey('EXIF DateTimeOriginal')) {
      creationDate = Utils.creationDateFormat.parse(exifData['EXIF DateTimeOriginal'].toString());
    }
    final yearMonth = Asset.toYearMonth(year: creationDate.year, month: creationDate.month);
    final assetUrl = (element.type == pm.AssetType.video) ? (await element.getMediaUrl())! : 'file://${(await element.file)!.path}';
    AssetType assetType = AssetType.Image;
    if (element.isLivePhoto) {
      assetType = AssetType.LivePhoto;
    }
    if (element.type == pm.AssetType.video) {
      assetType = AssetType.Video;
    }
    return Asset(id: element.id, assetUrl: assetUrl, assetType: assetType, creationDate: creationDate, yearMonth: yearMonth);
  }

  Future<Map<String, IfdTag>> _extractMetadata(pm.AssetEntity element) async {
    final bytes = await element.originBytes;
    if (bytes == null) {
      return {};
    }
    return await readExifFromBytes(bytes);
  }

  // CRUD operations.

  Future<Map<String, Asset>> _list() async {
    final entries = await _dbService.retrieve(DBTables.Assets);
    Map<String, Asset> results = {};
    for (var element in entries) {
      final asset = Asset.fromJson(element);
      results[asset.id] = asset;
    }
    return results;
  }

  Future<List<DateTime>> _listAvailableYearMonths() async {
    final entries = await _dbService.retrieve(
      DBTables.Assets,
      columns: ['creation_date'],
      groupBy: 'year_month',
      orderBy: 'year_month',
    );
    return entries.map((e) => Asset.creationDateFromJson(e)).toList();
  }

  Future<List<Asset>> _listForYearMonth({required int yearMonth}) async {
    final entries = await _dbService.retrieve(
      DBTables.Assets,
      where: 'year_month = ?',
      whereArgs: [yearMonth],
      orderBy: 'creation_date',
    );
    return entries.map((e) => Asset.fromJson(e)).toList();
  }

  Future<void> _create(Asset asset) async {
    await _dbService.create(DBTables.Assets, asset.toJson());
  }

  Future<void> _deleteAll(Set<String> ids) async {
    await _dbService.delete(DBTables.Assets,
      where: 'id IN (?)',
      whereArgs: [ids.join(',')],
    );
  }


}