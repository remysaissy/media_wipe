import 'package:app/src/data/local/models/session_entity.dart';
import 'package:isar/isar.dart';

class SessionLocalDataSource {
  final Isar _isar;

  SessionLocalDataSource(this._isar);

  Future<List<SessionEntity>> getAllSessions() async {
    return await _isar.sessionEntitys.where().findAll();
  }

  Future<SessionEntity?> getSessionById(int id) async {
    final session = await _isar.sessionEntitys.get(id);
    if (session != null) {
      // Load links
      await session.assetsToDrop.load();
      await session.refineAssetsToDrop.load();
      await session.assetInReview.load();
    }
    return session;
  }

  Future<SessionEntity?> getActiveSession() async {
    final sessions = await getAllSessions();
    if (sessions.isNotEmpty) {
      final session = sessions.first;
      // Load links
      await session.assetsToDrop.load();
      await session.refineAssetsToDrop.load();
      await session.assetInReview.load();
      return session;
    }
    return null;
  }

  Future<int> createSession(SessionEntity session) async {
    late int id;
    await _isar.writeTxn(() async {
      id = await _isar.sessionEntitys.put(session);
      await session.assetsToDrop.save();
      await session.refineAssetsToDrop.save();
      await session.assetInReview.save();
    });
    return id;
  }

  Future<void> updateSession(SessionEntity session) async {
    await _isar.writeTxn(() async {
      await _isar.sessionEntitys.put(session);
      await session.assetsToDrop.save();
      await session.refineAssetsToDrop.save();
      await session.assetInReview.save();
    });
  }

  Future<void> deleteSession(int id) async {
    await _isar.writeTxn(() async {
      await _isar.sessionEntitys.delete(id);
    });
  }

  Future<void> deleteAllSessions() async {
    await _isar.writeTxn(() async {
      await _isar.sessionEntitys.clear();
    });
  }
}
