import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class ResetSessionCommand extends AbstractCommand {

  ResetSessionCommand(super.context);

  Future<void> run({required int year, required int month}) async {
    final yearMonth = Utils.stringifyYearMonth(year: year, month: month);
    sessionsModel.sessions[yearMonth] = SessionData(assetIdsToDrop: [], isFinished: false);
  }
}