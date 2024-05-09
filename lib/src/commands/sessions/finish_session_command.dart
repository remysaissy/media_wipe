import 'package:app/src/commands/abstract_command.dart';

class FinishSessionCommand extends AbstractCommand {
  FinishSessionCommand(super.context);

  Future<void> run(
      {required int year, required int month, bool cancel = false}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null) return;
    if (cancel == false) {
      final assets = assetsModel.listAssets(
          forYear: year, forMonth: month, withAllowList: session.assetsToDrop);
      final removedAssetIds = await assetsService.deleteAssetsPerId(
          assetIds: assets.map((e) => e.assetId).toList(),
          isDry: settingsModel.settings.debugDryRemoval);
      final ids = assets
          .where((e) => removedAssetIds.contains(e.assetId))
          .map((e) => e.id)
          .toList();
      print('-> ${assetsModel.listAssets().length}');
      print('Removal of ${ids.length} elements');
      await assetsModel.removeAssetsFromList(ids: ids);
      print('-> ${assetsModel.listAssets().length}');
    }
    await sessionsModel.removeSessions(forYear: year, forMonth: month);
  }
}
