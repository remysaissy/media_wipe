
import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/commands/abstract_command.dart';

class BootstrapCommand extends AbstractCommand {

  BootstrapCommand(super.context);

  Future<void> run() async {
    // This permission can change from one launch to another.
    settingsModel.canAccessPhotoLibrary = await permissionsService.isPhotosAuthorized();
    settingsModel.canRequestInAppReview = await inAppReviewsService.isInAppReviewAvailable();
  }
}