import 'package:app/src/commands/abstract_command.dart';

class CancelSessionCommand extends AbstractCommand {
  CancelSessionCommand(super.context);

  Future<void> run({required int year, required int month}) async {
    final assets = assetsModel.listAssets(forYear: year, forMonth: month);
    for (var e in assets) {
      e.toDrop = false;
    }
    await assetsModel.updateAssets(assets: assets);
  }
}
