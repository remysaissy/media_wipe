import 'package:app/settings/views/authorize_view.dart';
import 'package:app/settings/views/list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

class SettingsRouter {
  static const list = "/settings";
  static const authorize = "/authorize";

  static StatefulShellBranch setup() {
    return StatefulShellBranch(
      initialLocation: SettingsRouter.list,
      navigatorKey: _settingsNavigatorKey,
      routes: [
        GoRoute(
          name: SettingsRouter.list,
          path: SettingsRouter.list,
          pageBuilder: (context, state) => MaterialPage(
            child: ListSettingsView(key: state.pageKey),
          ),
        ),
        GoRoute(
          path: SettingsRouter.authorize,
          name: SettingsRouter.authorize,
          pageBuilder: (context, state) => MaterialPage(
            child: AuthorizeView(key: state.pageKey),
          ),
        ),
      ],
    );
  }
}
