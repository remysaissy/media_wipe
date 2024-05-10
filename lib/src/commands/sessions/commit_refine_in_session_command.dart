import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/session.dart';

class CommitRefineInSessionCommand extends AbstractCommand {
  CommitRefineInSessionCommand(super.context);

  Future<void> run({required Session session}) async {
    // The refined list becomes the new drop list.
    session.assetsToDrop.clear();
    session.assetsToDrop.addAll(session.refineAssetsToDrop);
    session.refineAssetsToDrop.clear();
    await sessionsModel.updateSessions(sessions: [session]);
  }
}
