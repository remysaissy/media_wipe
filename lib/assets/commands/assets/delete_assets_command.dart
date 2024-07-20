import 'package:app/shared/commands/abstract_command.dart';
import 'package:app/assets/models/asset.dart';

class DeleteAssetsCommand extends AbstractCommand {
  DeleteAssetsCommand(super.context);

  Future<void> run({required List<Asset> assets}) async {
    final removedAssetIds = await assetsService.deleteAssetsPerId(
        assetIds: assets.map((e) => e.assetId).toList(),
        isDry: settingsModel.settings.debugDryRemoval);
    final ids = assets
        .where((e) => removedAssetIds.contains(e.assetId))
        .map((e) => e.id)
        .toList();
    await assetsModel.removeAssetsFromList(ids: ids);
  }
}
