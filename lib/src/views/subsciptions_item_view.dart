import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/models/app_model.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';

class SubscriptionItemView extends StatelessWidget {
  final SubscriptionData item;

  const SubscriptionItemView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(item.title, style: Theme.of(context).textTheme.titleMedium),
      Text(item.name, style: Theme.of(context).textTheme.bodyMedium),
      Text(item.price, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}
