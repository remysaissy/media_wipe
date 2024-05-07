import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:app/src/commands/abstract_command.dart';

class BootstrapCommand extends AbstractCommand {
  BootstrapCommand(super.context);

  Future<void> run(BuildContext context) async {
    // This permission can change from one launch to another.
    settings42Model.canAccessPhotoLibrary =
        await permissionsService.isPhotosAuthorized();
    appModel.canRequestInAppReview =
        await inAppReviewsService.isInAppReviewAvailable();
    appModel.onboardingPages = await appService.refreshOnboardingPages();
    settings42Model.subscriptionPlans = await appService.refreshSubscriptions();

    // Once bootstrap is done.
    appModel.appReady = true;
    FlutterNativeSplash.remove();
  }
}
