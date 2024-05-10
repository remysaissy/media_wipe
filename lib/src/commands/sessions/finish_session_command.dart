import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/commands/assets/delete_assets_command.dart';

class FinishSessionCommand extends AbstractCommand {
  FinishSessionCommand(super.context);

  Future<void> run(
      {required int year, required int month, bool cancel = false}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session == null) return;
    if (cancel == false) {
      final assets = assetsModel.listAssets(
          forYear: year, forMonth: month, withAllowList: session.assetsToDrop);
      await DeleteAssetsCommand(context).run(assets: assets);
    }
    await sessionsModel.removeSessions(forYear: year, forMonth: month);
  }
}
