import 'dart:async';

import 'package:exif/exif.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sqflite/sqflite.dart';

class Asset {
  final String id;
  final DateTime creationDate;
  final int yearMonth;

  Asset({
    required this.id,
    required this.creationDate,
    required this.yearMonth,
  });

  Asset.fromJson(Map<String, dynamic> json):
        id = json['id'] as String,
        creationDate = DateTime.fromMillisecondsSinceEpoch(json['creationDate'] as int),
        yearMonth = json['yearMonth'] as int;

  Map<String, dynamic> toJson() => {
    'id': id,
    'creationDate': creationDate.millisecondsSinceEpoch,
    'yearMonth': yearMonth,
  };
}

class AssetsService {

  final DateFormat _format = DateFormat("yyyy:MM:dd HH:mm:ss");
  late Database? _db = null;

  Future<void> _ensureDBConnIsOpened() async {
    if (_db != null && _db!.isOpen) {
      return;
    }

    // Open the database and store the reference.
    _db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'assets_service.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE assets(id TEXT, creationDate INTEGER, yearMonth INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> load() async {
    await _ensureDBConnIsOpened();
    await _db?.delete('assets');
  }

  Future<void> refresh() async {
    await _ensureDBConnIsOpened();
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
    print('registered IDs: ${registeredIDs}');
    print('processed IDs: ${processedIDs}');
    print('to be removed IDs: ${toRemoveIDs}');
    await _deleteAssets(toRemoveIDs);
  }

  Future<List<DateTime>?> listYearMonthAssets() async {
    await _ensureDBConnIsOpened();

    final entries = await _db!.query(
      'assets',
      groupBy: 'yearMonth',
      orderBy: 'yearMonth',
    );
    if (entries.isEmpty) {
      return null;
    }
    List<DateTime> yearMonths = [];
    for (Map<String, Object?> entry in entries) {
      Asset asset = Asset.fromJson(entry);
      print('Pulled: ${asset.creationDate} -- yearMonth: ${asset.yearMonth}');
      yearMonths.add(asset.creationDate);
    }
    return yearMonths;
  }

  final NumberFormat _monthFormatter = NumberFormat("00");
  final NumberFormat _yearFormatter = NumberFormat("0000");

  Future<void> _insertAssetFromRaw(AssetEntity element) async {
    final bytes = await element.originBytes;
    if (bytes != null) {
      final exifData = await readExifFromBytes(bytes);
      DateTime creationDate = element.createDateTime;
      if (exifData.containsKey('EXIF DateTimeOriginal')) {
        creationDate = _format.parse(exifData['EXIF DateTimeOriginal'].toString());
      }
      final yearMonth = int.parse('${_yearFormatter.format(creationDate.year)}${_monthFormatter.format(creationDate.month)}');
      final asset = Asset(id: element.id, creationDate: creationDate, yearMonth: yearMonth);
      print('Creation date: ${asset.creationDate} -- YearMonth: ${yearMonth}');
      await _insertAsset(asset);
    }
  }

  Future<Asset?> _assetById(String id) async {
    await _ensureDBConnIsOpened();

    final res = await _db!.query(
      'assets',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (res.isEmpty) {
      return null;
    }
    return Asset.fromJson(res.first);
  }

  Future<void> _insertAsset(Asset asset) async {
    await _ensureDBConnIsOpened();

    await _db!.insert(
      'assets',
      asset.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _deleteAssets(Set<String> ids) async {
    await _ensureDBConnIsOpened();

    await _db!.delete(
      'assets',
      where: 'id IN (?)',
      whereArgs: [ids.join(',')],
    );
  }

  Future<Map<String, Asset>> _assets() async {
    await _ensureDBConnIsOpened();

    final List<Map<String, Object?>> entries = await _db!.query('assets');
    Map<String, Asset> assets = {};
    for (Map<String, Object?> entry in entries) {
      Asset asset = Asset.fromJson(entry);
      assets[asset.id] = asset;
    }
    return assets;
  }
}