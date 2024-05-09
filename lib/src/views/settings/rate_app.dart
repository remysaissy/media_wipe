import 'package:app/src/commands/settings/request_in_app_review_command.dart';
import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RateApp extends StatelessWidget {
  const RateApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasInAppReview =
        context.watch<SettingsModel>().settings.hasInAppReview;
    return ListTile(
        onTap: !hasInAppReview
            ? null
            : () async {
          await RequestInAppReviewCommand(context).run();
        },
        leading: const Icon(Icons.star),
        title: const Text('Rate the app!'));
  }

}