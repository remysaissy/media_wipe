import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/sessions_model.dart';
import 'package:app/src/utils.dart';

class ResetSessionCommand extends AbstractCommand {

  ResetSessionCommand(super.context);

  Future<void> run({required int year, required int month}) async {
    final yearMonth = Utils.stringifyYearMonth(year: year, month: month);
    final sessionData = SessionData.empty();
    var sessions = sessionsModel.sessions;
    sessions[yearMonth] = sessionData;
    sessionsModel.sessions = sessions;
  }
}