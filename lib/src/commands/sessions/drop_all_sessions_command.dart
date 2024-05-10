import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/session.dart';

class DropAllSessionsCommand extends AbstractCommand {
  DropAllSessionsCommand(super.context);

  Future<void> run() async {
    await sessionsModel.removeSessions();
  }
}
