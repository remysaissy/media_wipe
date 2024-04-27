import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/commands/abstract_command.dart';

class BootstrapCommand extends AbstractCommand {
  BootstrapCommand(super.context);

  Future<void> run(BuildContext context) async {
    // This permission can change from one launch to another.
    settingsModel.canAccessPhotoLibrary =
        await permissionsService.isPhotosAuthorized();
    appModel.canRequestInAppReview =
        await inAppReviewsService.isInAppReviewAvailable();
    appModel.onboardingPages = await appService.refreshOnboardingPages();
    settingsModel.subscriptionPlans = await appService.refreshSubscriptions();

    // Once bootstrap is done.
    appModel.appReady = true;
  }
}
