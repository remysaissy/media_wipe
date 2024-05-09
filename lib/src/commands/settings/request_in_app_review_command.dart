import 'package:app/src/commands/abstract_command.dart';

class RequestInAppReviewCommand extends AbstractCommand {
  RequestInAppReviewCommand(super.context);

  Future<void> run() async {
    if (await inAppReviewsService.isInAppReviewAvailable() == false) {
      // appModel.canRequestInAppReview = false;
    } else {
      await inAppReviewsService.requestInAppReview();
    }
  }
}
