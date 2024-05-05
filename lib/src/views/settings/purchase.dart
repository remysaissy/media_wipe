import 'package:app/src/models/settings_model.dart';
import 'package:app/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Purchase extends StatelessWidget {
  const Purchase({super.key});

  @override
  Widget build(BuildContext context) {
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
      return Text('${subscriptionData.name}, $daysLeft days left');
    }
    return Text(
        '${subscriptionData.name} since ${Utils.monthNumberToMonthName(subscribedAt.month)} ${subscribedAt.year}');
  }
}