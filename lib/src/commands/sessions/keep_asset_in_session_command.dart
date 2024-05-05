import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/models/sessions_model.dart';
import 'package:app/src/utils.dart';

class KeepAssetInSessionCommand extends AbstractCommand {
  KeepAssetInSessionCommand(super.context);

  Future<void> run({required AssetData assetData}) async {
    final yearMonth = Utils.stringifyYearMonth(
        year: assetData.creationDate.year, month: assetData.creationDate.month);
    var sessions = sessionsModel.sessions;
    sessions[yearMonth]?.assetIdsToDrop.remove(assetData.id);
    sessionsModel.sessions = sessions;
  }
}
