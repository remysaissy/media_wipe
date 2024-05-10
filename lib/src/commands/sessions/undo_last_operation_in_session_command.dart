import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/asset.dart';
import 'package:app/src/models/session.dart';

class UndoLastOperationInSessionCommand extends AbstractCommand {
  UndoLastOperationInSessionCommand(super.context);

  Future<void> run(
      {required Session session,
      required bool isWhiteListMode}) async {
    if (session.assetInReview.target == null) return;
    final assets = assetsModel.listAssets(
        forYear: session.assetInReview.target?.creationDate.year,
        forMonth: session.assetInReview.target?.creationDate.month,
        withAllowList: isWhiteListMode == true ? session.assetsToDrop : null);

    final prevAssetInReview = _findPrevAssetToReview(assets, session);

    // Restore the previous state.
    // Don't remove when in whiteList mode as it is expected to have it in the drop list.
    if (isWhiteListMode) {
      session.refineAssetsToDrop.remove(prevAssetInReview);
    } else {
      session.assetsToDrop.remove(prevAssetInReview);
    }
    session.assetInReview.target = prevAssetInReview;
    await sessionsModel.updateSessions(sessions: [session]);
  }

  Asset? _findPrevAssetToReview(List<Asset> assets, Session session) {
    Asset? prevAssetInReview;
    for (int i = 0; i < assets.length; i++) {
      if (assets[i] == session.assetInReview.target) {
        if (i > 0) {
          prevAssetInReview = assets[i - 1];
        }
        break;
      }
    }
    return prevAssetInReview;
  }
}
