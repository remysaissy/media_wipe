import 'package:sortmaster_photos/src/commands/abstract_command.dart';

class RefreshPhotosCommand extends AbstractCommand {

  RefreshPhotosCommand(super.context);

  Future<void> run() async {
    final assets = await assetsService.listAssetsPerYearMonth();

    // // Remove assets that have been removed from the device since last refresh.
    // // Calculate IDs stored on DB that were not retrieved at all and remove it from DB.
    // final persistedAssets = assetsModel.assets;
    // final persistedIDs = persistedAssets.values.map((assetList) => assetList.map((asset) => asset.id)).toSet();
    // final newlyPersistedIDs = assets.values.map((assetList) => assetList.map((asset) => asset.id)).toSet();
    // final toRemoveIDs = persistedIDs.difference(newlyPersistedIDs.toSet());
    // await _deleteAll(toRemoveIDs);

    assetsModel.assets = assets;
  }
}