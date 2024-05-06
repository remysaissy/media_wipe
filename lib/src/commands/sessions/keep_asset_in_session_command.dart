import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/assets_model.dart';

class KeepAssetInSessionCommand extends AbstractCommand {
  KeepAssetInSessionCommand(super.context);

  Future<void> run({required AssetData assetData}) async {
    final index = assetsModel.assets.indexWhere((e) =>
        e.year == assetData.creationDate.year &&
        e.month == assetData.creationDate.month);
    if (index >= 0) {
      var assets = assetsModel.assets[index];
      assets.assetIdsToDrop.removeWhere((e) => e == assetData.assetId);
      assetsModel.setAssetsAt(index, assets);
    }
  }
}
