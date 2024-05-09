import 'package:app/src/commands/abstract_command.dart';

class FinishSessionCommand extends AbstractCommand {
  FinishSessionCommand(super.context);

  Future<void> run(
      {required int year, required int month, bool cancel = false}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null) return;
    if (cancel == false) {
      final assets = assetsModel.listAssets(forYear: year, forMonth: month, withAllowList: session.assetsToDrop);
      print('Assets count: ${assets.length} ${assets[0].id} ${assets[0].assetId}');
      final removedAssetIds = await assetsService
          .deleteAssetsPerId(assets.map((e) => e.assetId).toList());
      print('removedAssetIds count: ${removedAssetIds.length} ${removedAssetIds[0]}');
      final ids = assets
          .where((e) => removedAssetIds.contains(e.assetId))
          .map((e) => e.id)
          .toList();
      print('db IDs count: ${ids.length} ${ids[0]}');
      await assetsModel.removeAssetsFromList(ids: ids);
    }
    await sessionsModel.removeSessions(forYear: year, forMonth: month);
  }
}
