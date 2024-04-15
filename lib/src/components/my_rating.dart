import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rating_dialog/rating_dialog.dart';

Future<void> myRating(BuildContext context) async {
  final dialog = RatingDialog(initialRating: 1.0,
        title: const Text('Rate us!', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        message: const Text('Tap a star to set your rating. Add more description here if you want.',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
        // your app's logo?
        image: Image.asset('assets/icons/icon.png', height: 100, width: 100),
        submitButtonText: 'Submit',
        commentHint: 'Set your custom comment hint',
        onCancelled: () => context.pop(),
        onSubmitted: _onSubmitted);

  showDialog(
    context: context,
    barrierDismissible: true, // set to false if you want to force a rating
    builder: (context) => dialog,
  );
}

Future<void> _onSubmitted(RatingDialogResponse response) async {
  print('rating: ${response.rating}, comment: ${response.comment}');
  // // TODO: add your own logic
  // if (response.rating < 3.0) {
  //   // send their comments to your email or anywhere you wish
  //   // ask the user to contact you instead of leaving a bad review
  // } else {
  // refer to: https://pub.dev/packages/in_app_review
  final _inAppReview = InAppReview.instance;
  if (await _inAppReview.isAvailable()) {
    print('request actual review from store');
    _inAppReview.requestReview();
  } else {
    print('open actual store listing');
    // TODO: use your own store ids
    _inAppReview.openStoreListing(appStoreId: '<your app store id>');
  }
}