import 'package:app/src/commands/abstract_command.dart';

class ResetSessionCommand extends AbstractCommand {
  ResetSessionCommand(super.context);

  Future<void> run({required int year, required int month}) async {
    final index = assetsModel.assets
        .indexWhere((e) => e.year == year && e.month == month);
    if (index >= 0) {
      var assets = assetsModel.assets[index];
      assets.assetIdsToDrop = [];
      assetsModel.setAssetsAt(index, assets);
    }
  }
}
