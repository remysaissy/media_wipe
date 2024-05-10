import 'package:app/src/commands/abstract_command.dart';

class CommitRefineInSessionCommand extends AbstractCommand {
  CommitRefineInSessionCommand(super.context);

  Future<void> run({required int year, required int month}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null) return;
    // The refined list becomes the new drop list.
    session.assetsToDrop = session.refineAssetsToDrop;
    await sessionsModel.updateSessions(sessions: [session]);
  }
}
