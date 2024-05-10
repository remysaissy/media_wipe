import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/asset.dart';
import 'package:app/src/models/session.dart';

class KeepAssetInSessionCommand extends AbstractCommand {
  KeepAssetInSessionCommand(super.context);

  Future<void> run(
      {required Session session,
      required bool isWhiteListMode}) async {
    if (session.assetInReview.target == null) return;
    final assets = assetsModel.listAssets(
        forYear: session.assetInReview.target?.creationDate.year,
        forMonth: session.assetInReview.target?.creationDate.month,
        withAllowList:
            isWhiteListMode == true ? session.assetsToDrop : null);
    final nextAssetInReview = _findNextAssetIdToReview(assets, session);
    if (isWhiteListMode) {
      session.refineAssetsToDrop.remove(session.assetInReview.target);
    } else {
      session.assetsToDrop.remove(session.assetInReview.target);
    }
    session.assetInReview.target = nextAssetInReview;
    await sessionsModel.updateSessions(sessions: [session]);
  }

  Asset? _findNextAssetIdToReview(List<Asset> assets, Session session) {
    Asset? nextAssetInReview;
    for (int i = 0; i < assets.length; i++) {
      if (assets[i] == session.assetInReview.target) {
        if (i + 1 < assets.length) {
          nextAssetInReview = assets[i + 1];
        }
        break;
      }
    }
    return nextAssetInReview;
  }
}
