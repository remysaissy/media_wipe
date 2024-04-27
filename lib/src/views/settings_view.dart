import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/settings/authorize_photos_command.dart';
import 'package:sortmaster_photos/src/commands/settings/request_in_app_review_command.dart';
import 'package:sortmaster_photos/src/components/my_launch_url.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/components/my_theme_dropdown.dart';
import 'package:sortmaster_photos/src/models/app_model.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        child: ListView(
          children: [
            const MyThemeDropDown(),
            _buildPurchase(context),
            _buildAuthorizePhotos(context),
            _buildRateApp(context),
            _buildLink(context, 'Terms of service',
                'https://www.app-privacy-policy.com/'),
            _buildLink(context, 'Privacy Policy',
                'https://www.app-privacy-policy.com/'),
          ],
        ));
  }

  Widget _buildAuthorizePhotos(BuildContext context) {
    bool canAccessPhotoLibrary = context
        .select<SettingsModel, bool>((value) => value.canAccessPhotoLibrary);
    return ListTile(
        onTap: canAccessPhotoLibrary
            ? null
            : () async {
                if (!canAccessPhotoLibrary) {
                  await AuthorizePhotosCommand(context).run();
                }
              },
        leading: const Icon(Icons.camera),
        title: const Text('Authorize access to photos'),
        trailing: canAccessPhotoLibrary
            ? const Icon(Icons.check)
            : const Icon(Icons.arrow_forward_ios));
  }

  Widget _buildRateApp(BuildContext context) {
    bool canRequestInAppReview =
        context.select<AppModel, bool>((value) => value.canRequestInAppReview);
    return ListTile(
        onTap: !canRequestInAppReview
            ? null
            : () async {
                await RequestInAppReviewCommand(context).run();
              },
        leading: const Icon(Icons.star),
        title: const Text('Rate the app!'));
  }

  Widget _buildLink(BuildContext context, String title, String targetURL) {
    return ListTile(
        onTap: () async {
          await myLaunchURL(context, targetURL);
        },
        leading: const Icon(Icons.web),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios));
  }

  Widget _buildPurchase(BuildContext context) {
    bool hasSubscription =
        context.select<SettingsModel, bool>((value) => value.hasSubscription);
    SubscriptionData? subscription =
        context.select<SettingsModel, SubscriptionData?>(
            (value) => value.currentSubscription);
    DateTime subscribedAt =
        context.select<SettingsModel, DateTime>((value) => value.subscribedAt);
    return ListTile(
        onTap: hasSubscription
            ? null
            : () {
                if (!context.mounted) return;
                context.push('/subscriptions');
              },
        leading: const Icon(Icons.shopping_cart),
        title: hasSubscription
            ? _buildSubscriptionText(subscription, subscribedAt)
            : const Text('Purchase'),
        trailing: hasSubscription
            ? const Icon(Icons.check)
            : const Icon(Icons.arrow_forward_ios));
  }

  Widget _buildSubscriptionText(
      SubscriptionData? subscriptionData, DateTime subscribedAt) {
    if (subscriptionData == null) {
      return const Text('Already subscribed');
    }
    if (subscriptionData.productId == 'free') {
      final daysLeft = 3 - subscribedAt.difference(DateTime.now()).inDays;
      // .compareTo(const Duration(days: 3));
      return Text('${subscriptionData.name}, ${daysLeft} days left');
    }
    return Text(
        '${subscriptionData.name} since ${Utils.monthNumberToMonthName(subscribedAt.month)} ${subscribedAt.year}');
  }
}
