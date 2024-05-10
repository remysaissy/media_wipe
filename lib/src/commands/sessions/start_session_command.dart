import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/session.dart';

class StartSessionCommand extends AbstractCommand {
  StartSessionCommand(super.context);

  Future<void> run(
      {required int year,
      required int month,
      required bool isWhiteListMode}) async {
    // await sessionsModel.removeSessions(forYear: year, forMonth: month);
    var session = sessionsModel.getSession(year: year, month: month);
    if (session != null) {
      await _restoreSession(year, month, session, isWhiteListMode);
    } else {
      await _createSession(year, month);
    }
  }

  Future<void> _createSession(int year, int month) async {
    final assets = assetsModel.listAssets(forYear: year, forMonth: month);
    final session = Session(
        assetsToDrop: [],
        assetIdInReview: assets.firstOrNull?.id,
        sessionYear: year,
        sessionMonth: month);
    await sessionsModel.addSessions(sessions: [session]);
  }

  Future<void> _restoreSession(
      int year, int month, Session session, bool isWhiteListMode) async {
    // If the session already exists and we are in whiteList mode, we are refining the deletion list.
    if (isWhiteListMode == true) {
      final assets = assetsModel
          .listAssets(forYear: year, forMonth: month)
          .where((e) => session.assetsToDrop.contains(e.id))
          .toList();
      // use this duplicated drop list during the refining process.
      session.refineAssetsToDrop = session.assetsToDrop;
      session.assetIdInReview = assets.firstOrNull?.id;
    }
    await sessionsModel.updateSessions(sessions: [session]);
  }
}
