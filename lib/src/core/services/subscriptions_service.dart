import 'package:in_app_review/in_app_review.dart';

class SubscriptionsService {
  Future<String?> restorePurchase() async {
    //     //Flow:
    //     // - check for restore against the store
    //     // - persist the restored plan information locally
    //     // - return the restored plan
    return 'free';
  }

  Future<bool> purchase({required String productId}) async {
    //     //Flow:
    //     // - buy the plan against the store
    //     // - create the plan object
    //     // - persist the plan information locally
    //     // - return the purchased plan
    return true;
  }

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
