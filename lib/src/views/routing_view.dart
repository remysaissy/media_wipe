import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/src/models/settings42_model.dart';
import 'package:app/src/views/loading_view.dart';

class RoutingView extends StatelessWidget {
  const RoutingView({super.key});

  void _go(BuildContext context, String location) {
    Future.delayed(const Duration(milliseconds: 10), () {
      context.go(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final isOnboarded =
    //     context.select<SettingsModel, bool>((value) => value.isOnboarded);
    // if (!isOnboarded) {
    //   _go(context, '/onboarding');
    // } else {
    //   final hasSubscription =
    //       context.select<SettingsModel, bool>((value) => value.hasSubscription);
    //   if (!hasSubscription) {
    //     _go(context, '/subscriptions');
    //   } else {
    final canAccessPhotoLibrary = context.select<Settings42Model, bool>(
        (value) => value.canAccessPhotoLibrary);
    if (!canAccessPhotoLibrary) {
      _go(context, '/authorize');
    } else {
      _go(context, '/photos');
    }
      // }
    // }
    return const LoadingView();
  }
}
