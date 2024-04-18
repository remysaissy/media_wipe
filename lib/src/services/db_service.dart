import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

enum DBTables {
  Assets,
  Sessions,
  SessionItems,
}

class DBService {

  final int SCHEMA_VERSION = 1;
  late Database _db;
  Database get db => _db;

  Future<void> init() async {
    final dbPath = join(await getDatabasesPath(), 'app.db');
    // if (kDebugMode) {
    //   final dbFile = File(dbPath);
    //   if (dbFile.existsSync()) {
    //     dbFile.deleteSync();
    //   }
    // }
    _db = await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        final schema = await rootBundle.loadString('assets/schemas/v$SCHEMA_VERSION.sql');
        await db.execute(schema);
      },
      version: SCHEMA_VERSION,
    );
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