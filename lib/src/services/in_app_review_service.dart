import 'package:in_app_review/in_app_review.dart';

class InAppReviewsService {
  Future<void> requestInAppReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  Future<bool> isInAppReviewAvailable() async {
    final inAppReview = InAppReview.instance;
    return await inAppReview.isAvailable();
  }
}
