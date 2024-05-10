import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/asset.dart';
import 'package:app/src/models/session.dart';

class UndoLastOperationInSessionCommand extends AbstractCommand {
  UndoLastOperationInSessionCommand(super.context);

  Future<void> run(
      {required int year,
      required int month,
      required bool isWhiteListMode}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null) return;
    final assets = assetsModel
        .listAssets(forYear: year, forMonth: month, withAllowList: isWhiteListMode == true ? session.assetsToDrop : null);

    int? prevAssetIdInReview = _findPrevAssetIdToReview(assets, session);

    // Restore the previous state.
    // Don't remove when in whiteList mode as it is expected to have it in the drop list.
    if (isWhiteListMode) {
      session.refineAssetsToDrop?.remove(prevAssetIdInReview);
    } else {
      session.assetsToDrop.remove(prevAssetIdInReview);
    }
    session.assetIdInReview = prevAssetIdInReview;
    await sessionsModel.updateSessions(sessions: [session]);
  }

  int? _findPrevAssetIdToReview(List<Asset> assets, Session session) {
    int? prevAssetIdInReview;
    for (int i = 0; i < assets.length; i++) {
      if (assets[i].id == session.assetIdInReview) {
        if (i > 0) {
          prevAssetIdInReview = assets[i-1].id;
        }
        break;
      }
    }
    return prevAssetIdInReview;
  }
}
