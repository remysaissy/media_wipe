import 'dart:async';

import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/assets/assets_model.dart';
import 'package:sqflite/sqflite.dart';

class AssetsService {

  final DateFormat _creationDateFormat = DateFormat("yyyy:MM:dd HH:mm:ss");
  final NumberFormat _monthFormatter = NumberFormat("00");
  final NumberFormat _yearFormatter = NumberFormat("0000");
  late Database _db;

  Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'assets_service.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE assets(id TEXT, creationDate INTEGER, yearMonth INTEGER)',
        );
      },
      version: 1,
    );
    // In emulator mode, flush the DB at every start.
    if (kDebugMode) {
      await _db.delete('assets');
    }
  }

  Future<void> refresh() async {
    final assetsFromDB = await _assets();
    final Set<String> processedIDs = {};
    final type = RequestType.fromTypes([RequestType.image, RequestType.video]);
    final count = await PhotoManager.getAssetCount(type: type);
    for (int index = 0; index < count; index += 100) {
      final assets = await PhotoManager.getAssetListRange(start: index, end: index + 100, type: type);
      for (AssetEntity asset in assets) {
        if (!assetsFromDB.containsKey(asset.id)) {
          await _insertAssetFromRaw(asset);
        }
        processedIDs.add(asset.id);
      }
    }
    // Remove old assets that are no longer on the device.
    Set<String> registeredIDs = assetsFromDB.keys.toSet();
    final toRemoveIDs = registeredIDs.difference(processedIDs);
    await _deleteAssets(toRemoveIDs);
  }

  Future<List<AssetModel>?> listAssetsByYearMonth(int year, int month) async {
    final yearMonth = int.parse('${_yearFormatter.format(year)}${_monthFormatter.format(month)}');
    final entries = await _db.query(
      'assets',
      where: 'yearMonth = ?',
      whereArgs: [yearMonth],
      orderBy: 'creationDate',
    );
    if (entries.isEmpty) {
      return null;
    }
    return entries.map((e) => AssetModel.fromJson(e)).toList();
  }

  Future<List<DateTime>?> listYearMonthAssets() async {
    final entries = await _db.query(
      'assets',
      groupBy: 'yearMonth',
      orderBy: 'yearMonth',
    );
    if (entries.isEmpty) {
      return null;
    }
    List<DateTime> yearMonths = [];
    for (Map<String, Object?> entry in entries) {
      AssetModel asset = AssetModel.fromJson(entry);
      // print('Pulled: ${asset.creationDate} -- yearMonth: ${asset.yearMonth}');
      yearMonths.add(asset.creationDate);
    }
    return yearMonths;
  }

  Future<void> _insertAssetFromRaw(AssetEntity element) async {
    final bytes = await element.originBytes;
    if (bytes != null) {
      final exifData = await readExifFromBytes(bytes);
      DateTime creationDate = element.createDateTime;
      if (exifData.containsKey('EXIF DateTimeOriginal')) {
        creationDate = _creationDateFormat.parse(exifData['EXIF DateTimeOriginal'].toString());
      }
      final yearMonth = int.parse('${_yearFormatter.format(creationDate.year)}${_monthFormatter.format(creationDate.month)}');
      final asset = AssetModel(id: element.id, creationDate: creationDate, yearMonth: yearMonth);
      // print('Creation date: ${asset.creationDate} -- YearMonth: ${yearMonth}');
      await _insertAsset(asset);
    }
  }

  Future<AssetModel?> _assetById(String id) async {
    final res = await _db.query(
      'assets',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (res.isEmpty) {
      return null;
    }
    return AssetModel.fromJson(res.first);
  }

  Future<void> _insertAsset(AssetModel asset) async {
    await _db.insert(
      'assets',
      asset.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _deleteAssets(Set<String> ids) async {
    await _db.delete(
      'assets',
      where: 'id IN (?)',
      whereArgs: [ids.join(',')],
    );
  }

  Future<Map<String, AssetModel>> _assets() async {
    final List<Map<String, Object?>> entries = await _db.query('assets');
    Map<String, AssetModel> assets = {};
    for (Map<String, Object?> entry in entries) {
      AssetModel asset = AssetModel.fromJson(entry);
      assets[asset.id] = asset;
    }
    return assets;
  }
}