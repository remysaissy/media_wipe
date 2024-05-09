import 'package:app/src/commands/abstract_command.dart';

class KeepAssetInSessionCommand extends AbstractCommand {
  KeepAssetInSessionCommand(super.context);

  Future<void> run({required int year, required int month, required int assetId, required int? nextAssetId}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null) return;
    session.assetsToDrop.remove(assetId);
    session.assetIdInReview = nextAssetId;
    await sessionsModel.updateSessions(sessions: [session]);
    print('Keep Session: ${session.id} - Drop count: ${session.assetsToDrop.length} - AssetID: ${assetId} - NextAssetId: ${nextAssetId}');
  }
}
