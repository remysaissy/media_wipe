import 'package:app/src/commands/abstract_command.dart';

class AuthorizePhotosCommand extends AbstractCommand {
  AuthorizePhotosCommand(super.context);

  Future<void> run() async {
    if (await settingsService.isPhotosAuthorized() == false) {
      await settingsService.authorizePhotos();
    }
    final isGranted = await settingsService.isPhotosAuthorized();
    settingsModel.settings.hasPhotosAccess = isGranted;
    await settingsModel.updateSettings();
  }
}
