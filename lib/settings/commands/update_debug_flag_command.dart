import 'package:app/shared/commands/abstract_command.dart';

class UpdateDebugFlagCommand extends AbstractCommand {
  UpdateDebugFlagCommand(super.context);

  Future<void> run({bool? debugDryRemoval}) async {
    if (debugDryRemoval != null) {
      settingsModel.settings.debugDryRemoval = debugDryRemoval;
    }
    await settingsModel.updateSettings();
  }
}
