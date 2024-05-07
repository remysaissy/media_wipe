import 'package:app/src/commands/abstract_command.dart';

class KeepAssetInSessionCommand extends AbstractCommand {
  KeepAssetInSessionCommand(super.context);

  Future<void> run({required int id}) async {
    final asset = assetsModel.getAsset(id: id);
    if (asset != null) {
      asset.toDrop = false;
      await assetsModel.updateAssets(assets: [asset]);
    }
  }
}
