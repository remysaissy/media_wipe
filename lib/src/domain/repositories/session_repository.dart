import 'package:app/src/domain/entities/session.dart';

abstract class SessionRepository {
  Future<List<Session>> getAllSessions();
  Future<Session?> getSessionById(int id);
  Future<Session?> getActiveSession();
  Future<int> createSession(Session session);
  Future<void> updateSession(Session session);
  Future<void> deleteSession(int id);
  Future<void> deleteAllSessions();
}
