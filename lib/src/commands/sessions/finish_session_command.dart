import 'package:app/src/commands/abstract_command.dart';

class FinishSessionCommand extends AbstractCommand {
  FinishSessionCommand(super.context);

  Future<void> run({required int year, required int month}) async {
    final assets =
        assetsModel.listAssets(forYear: year, forMonth: month, toDrop: true);
    final removedAssetIds = await assetsService
        .deleteAssetsPerId(assets.map((e) => e.assetId).toList());
    final ids = assets
        .where((e) => removedAssetIds.contains(e.assetId))
        .map((e) => e.id)
        .toList();
    await assetsModel.removeAssetsFromList(ids: ids);
    await assetsModel.fetchAssets();
  }
}
