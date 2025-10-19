import 'package:in_app_review/in_app_review.dart';

class RequestInAppReviewUseCase {
  Future<void> execute() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }

  Future<bool> isAvailable() async {
    final inAppReview = InAppReview.instance;
    return await inAppReview.isAvailable();
  }
}
