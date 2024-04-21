import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

enum DBTables {
  Assets,
  Sessions,
  Settings,
}

class DBService {

  final int SCHEMA_VERSION = 1;
  late Database _db;

  Future<DBService> init() async {
    final dbPath = join(await getDatabasesPath(), 'app.db');
    // if (kDebugMode) {
      final dbFile = File(dbPath);
      if (dbFile.existsSync()) {
        dbFile.deleteSync();
      }
    // }
    _db = await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        final batch = db.batch();
        batch.execute(await rootBundle.loadString('assets/schemas/v$version/assets.sql'));
        batch.execute(await rootBundle.loadString('assets/schemas/v$version/sessions.sql'));
        await batch.commit();
      },
      version: SCHEMA_VERSION,
    );
      return this;
  }

  Future<int> create(DBTables table, Map<String, Object?> values) async {
    return await _db.insert(table.name.toLowerCase(), values, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<int> update(DBTables table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs}) async {
    return await _db.update(table.name.toLowerCase(), values, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, Object?>>> retrieve(DBTables table,
      {bool? distinct,
        List<String>? columns,
        String? where,
        List<Object?>? whereArgs,
        String? groupBy,
        String? having,
        String? orderBy,
        int? limit,
        int? offset}) async {
    return await _db.query(table.name.toLowerCase(),
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
  }

  Future<int> delete(DBTables table, {String? where, List<Object?>? whereArgs}) async {
    return await _db.delete(table.name.toLowerCase(), where: where, whereArgs: whereArgs);
  }
}