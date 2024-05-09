import 'package:app/src/commands/abstract_command.dart';

class DropAssetInSessionCommand extends AbstractCommand {
  DropAssetInSessionCommand(super.context);

  Future<void> run({required int year, required int month, required int assetId, required int? nextAssetId}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null) return;
    if (!session.assetsToDrop.contains(assetId)) {
      session.assetsToDrop.add(assetId);
    }
    session.assetIdInReview = nextAssetId;
    await sessionsModel.updateSessions(sessions: [session]);
    print('Drop Session: ${session.id} - Drop count: ${session.assetsToDrop.length} - AssetID: ${assetId} - NextAssetId: ${nextAssetId}');
  }
}
