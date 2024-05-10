import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/asset.dart';
import 'package:app/src/models/session.dart';

class DropAssetInSessionCommand extends AbstractCommand {
  DropAssetInSessionCommand(super.context);

  Future<void> run(
      {required int year,
      required int month,
      required bool isWhiteListMode}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null || session.assetInReview.target == null) return;
    final assets = assetsModel.listAssets(
        forYear: year,
        forMonth: month,
        withAllowList: isWhiteListMode == true ? session.assetsToDrop : null);

    final nextAssetInReview = _findNextAssetToReview(assets, session);

    if (isWhiteListMode) {
      if (!session.refineAssetsToDrop.contains(session.assetInReview.target)) {
        session.refineAssetsToDrop.add(session.assetInReview.target!);
      }
    } else {
      if (!session.assetsToDrop.contains(session.assetInReview.target)) {
        session.assetsToDrop.add(session.assetInReview.target!);
      }
    }

    session.assetInReview.target = nextAssetInReview;
    await sessionsModel.updateSessions(sessions: [session]);
  }

  Asset? _findNextAssetToReview(List<Asset> assets, Session session) {
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
