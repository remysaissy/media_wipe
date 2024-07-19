import 'package:app/src/models/settings_model.dart';
import 'package:app/src/views/authorize_view.dart';
import 'package:app/src/views/listing/years_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/src/views/loading_view.dart';

class RoutingView extends StatelessWidget {
  static String routeName = 'root';

  const RoutingView({super.key});

  void _go(BuildContext context, String location) {
    Future.delayed(const Duration(milliseconds: 10), () {
      context.goNamed(location);
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
    final hasPhotosAccess =
        context.watch<SettingsModel>().settings.hasPhotosAccess;
    if (!hasPhotosAccess) {
      _go(context, AuthorizeView.routeName);
    } else {
      _go(context, YearsView.routeName);
    }
    // }
    // }
    return const LoadingView();
  }
}
