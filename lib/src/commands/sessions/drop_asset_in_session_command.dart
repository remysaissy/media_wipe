import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/assets_model.dart';

class DropAssetInSessionCommand extends AbstractCommand {
  DropAssetInSessionCommand(super.context);

  Future<void> run({required AssetData assetData}) async {
    final index = assetsModel.assets.indexWhere((e) =>
        e.year == assetData.creationDate.year &&
        e.month == assetData.creationDate.month);
    if (index >= 0) {
      var assets = assetsModel.assets[index];
      assets.assetIdsToDrop.add(assetData.id);
      assetsModel.setAssetsAt(index, assets);
    }
  }
}
