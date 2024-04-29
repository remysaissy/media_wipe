import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:sortmaster_photos/src/views/loading_view.dart';

class RoutingView extends StatelessWidget {
  const RoutingView({super.key});

  void _go(BuildContext context, String location) {
    Future.delayed(const Duration(milliseconds: 10), () {
      context.go(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOnboarded =
        context.select<SettingsModel, bool>((value) => value.isOnboarded);
    final hasSubscription =
    context.select<SettingsModel, bool>((value) => value.hasSubscription);
    if (isOnboarded) {
      if (!hasSubscription) {
        _go(context, '/subscriptions');
      } else {
        _go(context, '/photos');
      }
    } else {
      _go(context, '/onboarding');
    }
    return const LoadingView();
  }
}
