import 'package:app/shared/commands/abstract_command.dart';
import 'package:app/assets/models/session.dart';

class StartSessionCommand extends AbstractCommand {
  StartSessionCommand(super.context);

  Future<void> run(
      {required int year,
      required int month,
      required bool isWhiteListMode}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session != null) {
      await _restoreSession(year, month, session, isWhiteListMode);
    } else {
      await _createSession(year, month);
    }
  }

  Future<void> _createSession(int year, int month) async {
    final assets = assetsModel.listAssets(forYear: year, forMonth: month);
    var session =
        Session(sessionYear: year, sessionMonth: month);
    session.assetInReview.target = assets.firstOrNull;
    await sessionsModel.addSessions(sessions: [session]);
  }

  Future<void> _restoreSession(
      int year, int month, Session session, bool isWhiteListMode) async {
    // If the session already exists and we are in whiteList mode, we are refining the deletion list.
    if (isWhiteListMode == true) {
      final assets = assetsModel
          .listAssets(forYear: year, forMonth: month, withAllowList: session.assetsToDrop)
          .toList();
      // use this duplicated drop list during the refining process.
      session.refineAssetsToDrop.clear();
      session.refineAssetsToDrop.addAll(session.assetsToDrop);
      session.assetInReview.target = assets.firstOrNull;
    }
    await sessionsModel.updateSessions(sessions: [session]);
  }
}
