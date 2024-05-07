import 'package:app/src/commands/abstract_command.dart';

class DropAssetInSessionCommand extends AbstractCommand {
  DropAssetInSessionCommand(super.context);

  Future<void> run({required int id}) async {
    final asset = assetsModel.getAsset(id: id);
    if (asset != null) {
      asset.toDrop = true;
      await assetsModel.updateAssets(assets: [asset]);
    }
  }
}
