import 'package:app/shared/commands/abstract_command.dart';
import 'package:app/assets/models/asset.dart';
import 'package:app/assets/models/session.dart';

class DropAssetInSessionCommand extends AbstractCommand {
  DropAssetInSessionCommand(super.context);

  Future<void> run(
      {required Session session,
      required bool isWhiteListMode}) async {
    if (session.assetInReview.target == null) return;
    final assets = assetsModel.listAssets(
        forYear: session.assetInReview.target?.creationDate.year,
        forMonth: session.assetInReview.target?.creationDate.month,
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
