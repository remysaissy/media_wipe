
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/services/db_service.dart';
import 'package:watch_it/watch_it.dart';

class SessionsService {

  late DBService _dbService;

  Future<void> init() async {
    _dbService = di<DBService>();
  }

  Future<Session> createOrRecoverSession({required int year, required int month, required String firstAssetId}) async {
    final yearMonth = Asset.toYearMonth(year: year, month: month);
    Session? session = await _getByYearMonth(yearMonth: yearMonth);
    if (session == null) {
      session = Session(currentAssetId: firstAssetId, yearMonth: yearMonth, assetIdsToDrop: []);
      await _create(session);
    }
    return session;
  }

  Future<void> updateSession({required Session session}) async {
    await _update(session);
  }

  Future<Session?> _getByYearMonth({required int yearMonth}) async {
    final entries = await _dbService.retrieve(
      DBTables.Sessions,
      where: 'year_month = ?',
      whereArgs: [yearMonth],
      limit: 1
    );
    return entries.isEmpty ? null : Session.fromJson(entries.first);
  }

  Future<void> _create(Session session) async {
    await _dbService.create(DBTables.Sessions, session.toJson());
  }

  Future<void> _update(Session session) async {
    await _dbService.update(DBTables.Sessions, session.toJson());
  }

  Future<void> _delete(int id) async {
    await _dbService.delete(DBTables.Sessions,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> finishSession({required Session session}) async {
    // Update the session with its latest assets to drop, in case of.
    await _update(session);
    if (session.assetIdsToDrop.isNotEmpty) {
      await PhotoManager.editor.deleteWithIds(session.assetIdsToDrop);
    }
    await _delete(session.id!);
  }
}