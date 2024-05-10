import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/asset.dart';
import 'package:app/src/models/session.dart';

class DropAssetInSessionCommand extends AbstractCommand {
  DropAssetInSessionCommand(super.context);

  Future<void> run({required int year, required int month, required bool isWhiteListMode}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null || session.assetIdInReview == null) return;
    final assets = assetsModel.listAssets(forYear: year, forMonth: month, withAllowList: isWhiteListMode == true ? session.assetsToDrop : null);

    int? nextAssetIdInReview = _findNextAssetIdToReview(assets, session);

    if (isWhiteListMode) {
      if (!session.refineAssetsToDrop!.contains(session.assetIdInReview)) {
        session.refineAssetsToDrop?.add(session.assetIdInReview!);
      }
    } else {
      if (!session.assetsToDrop.contains(session.assetIdInReview)) {
        session.assetsToDrop.add(session.assetIdInReview!);
      }
    }

    session.assetIdInReview = nextAssetIdInReview;
    await sessionsModel.updateSessions(sessions: [session]);
  }

  int? _findNextAssetIdToReview(List<Asset> assets, Session session) {
    int? nextAssetIdInReview;
    for (int i = 0; i < assets.length; i++) {
      if (assets[i].id == session.assetIdInReview) {
        if (i + 1 < assets.length) {
          nextAssetIdInReview = assets[i+1].id;
        }
        break;
      }
    }
    return nextAssetIdInReview;
  }
}
