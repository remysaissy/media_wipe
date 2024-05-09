import 'package:app/src/commands/abstract_command.dart';

class KeepAssetInSessionCommand extends AbstractCommand {
  KeepAssetInSessionCommand(super.context);

  Future<void> run({required int year, required int month, required bool isWhiteListMode}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null || session.assetIdInReview == null) return;
    final assets = assetsModel.listAssets(forYear: year, forMonth: month).where((e) => (isWhiteListMode == false || session.assetsToDrop.contains(e.id))).toList();

    int? nextAssetIdInReview;
    for (int i = 0; i < assets.length; i++) {
      if (assets[i].id == session.assetIdInReview) {
        if (i + 1 < assets.length) {
          nextAssetIdInReview = assets[i + 1].id;
        }
        break;
      }
    }

    if (isWhiteListMode) {
      session.refineAssetsToDrop?.remove(session.assetIdInReview!);
    } else {
      session.assetsToDrop.remove(session.assetIdInReview!);
    }
    session.assetIdInReview = nextAssetIdInReview;
    await sessionsModel.updateSessions(sessions: [session]);
  }
}
