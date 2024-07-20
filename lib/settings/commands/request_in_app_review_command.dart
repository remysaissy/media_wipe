import 'package:app/shared/commands/abstract_command.dart';

class RequestInAppReviewCommand extends AbstractCommand {
  RequestInAppReviewCommand(super.context);

  Future<void> run() async {
    if (await subscriptionsService.isInAppReviewAvailable() == false) {
      // appModel.canRequestInAppReview = false;
    } else {
      await subscriptionsService.requestInAppReview();
    }
  }
}
