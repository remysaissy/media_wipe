import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class DropAssetInSessionCommand extends AbstractCommand {
  DropAssetInSessionCommand(super.context);

  Future<void> run({required AssetData assetData}) async {
    final yearMonth = Utils.stringifyYearMonth(
        year: assetData.creationDate.year, month: assetData.creationDate.month);
    SessionData sessionData;
    if (sessionsModel.sessions.containsKey(yearMonth)) {
      sessionData = sessionsModel.sessions[yearMonth]!;
    } else {
      sessionData = SessionData.empty();
    }
    if (!sessionData.assetIdsToDrop.contains(assetData.id)) {
      sessionData.assetIdsToDrop.add(assetData.id);
    }
    sessionsModel.sessions[yearMonth] = sessionData;
  }
}
