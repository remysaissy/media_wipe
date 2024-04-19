
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/services/db_service.dart';
import 'package:watch_it/watch_it.dart';

class SessionsService {

  late DBService _dbService;

  Future<SessionsService> init() async {
    _dbService = di<DBService>();
    return this;
  }

  Future<Session> createOrRecoverSession({required int yearMonth, required String firstAssetId}) async {
    Session? session = await _getByYearMonth(yearMonth: yearMonth);
    print('Session: ${session}');
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
    session.id = await _dbService.create(DBTables.Sessions, session.toJson());
  }

  Future<void> _update(Session session) async {
    var values = session.toJson();
    values.remove('id');
    await _dbService.update(DBTables.Sessions,
        values, where: 'id = ?', whereArgs: [session.id]);
  }

  Future<void> _delete(int id) async {
    await _dbService.delete(DBTables.Sessions,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> finishSession({required Session session, bool isCanceled = false}) async {
    // Update the session with its latest assets to drop, in case of.
    await _update(session);
    if (!isCanceled) {
      if (session.assetIdsToDrop.isNotEmpty) {
        print('Drop all IDs: ${session.assetIdsToDrop}');
        // await PhotoManager.editor.deleteWithIds(session.assetIdsToDrop);
      }
    }
    await _delete(session.id!);
  }
}