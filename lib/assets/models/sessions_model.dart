import 'package:app/assets/models/session.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:objectbox/objectbox.dart';

class SessionsModel extends ChangeNotifier {
  final Box<Session> _sessionsBox;

  SessionsModel(this._sessionsBox);

  List<Session> _sessions = [];

  /// Use for initial loading.
  Future<SessionsModel> load() async {
    await fetchSessions();
    return this;
  }

  /// Pivotal method to fetch the up to date list of sessions from storage.
  Future<void> fetchSessions() async {
    _sessions = _sessionsBox.getAll();
    notifyListeners();
  }

  Session? getSession({int? id, int? year, int? month}) {
    return _sessions
        .where((e) =>
            (id == null || e.id == id) &&
            (year == null || e.sessionYear == year) &&
            (month == null || e.sessionMonth == month))
        .firstOrNull;
  }

  List<Session> listSessions({int? forYear, int? forMonth}) {
    return _sessions
        .where((e) =>
            (forYear == null || e.sessionYear == forYear) &&
            (forMonth == null || e.sessionMonth == forMonth))
        .toList();
  }

  Future<void> updateSessions({required List<Session> sessions}) async {
    if (sessions.isNotEmpty) {
      await _sessionsBox.putManyAsync(sessions, mode: PutMode.update);
      await fetchSessions();
    }
  }

  Future<void> removeSessions({int? forYear, int? forMonth}) async {
    final ids = _sessions
        .where((e) =>
            (forYear == null || e.sessionYear == forYear) &&
            (forMonth == null || e.sessionMonth == forMonth))
        .map((e) => e.id)
        .toList();
    if (ids.isNotEmpty) {
      await _sessionsBox.removeManyAsync(ids);
      await fetchSessions();
    }
  }

  Future<void> removeSessionsFromList({required List<int> ids}) async {
    if (ids.isNotEmpty) {
      await _sessionsBox.removeManyAsync(ids);
      await fetchSessions();
    }
  }

  Future<List<int>> addSessions({required List<Session> sessions}) async {
    final ids = await _sessionsBox.putManyAsync(sessions, mode: PutMode.insert);
    if (ids.isNotEmpty) {
      await fetchSessions();
    }
    return ids;
  }
}
