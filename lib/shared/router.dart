import 'package:app/assets/router.dart';
import 'package:app/settings/models/settings_model.dart';
import 'package:app/settings/router.dart';
import 'package:app/shared/views/loading_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const root = '/';

  static GoRouter setupRoutes() {
    return GoRouter(
      initialLocation: root,
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: kDebugMode,
      routes: [
        GoRoute(
            path: AppRouter.root,
            name: AppRouter.root,
            redirect: (context, __) {
              final hasPhotosAccess =
                  context.read<SettingsModel>().settings.hasPhotosAccess;
              if (!hasPhotosAccess) {
                return SettingsRouter.authorize;
              }
              return AssetsRouter.list;
            }),
        StatefulShellRoute.indexedStack(
          builder: (context, state, child) {
            return child;
          },
          branches: [
            AssetsRouter.setup(),
            SettingsRouter.setup(),
          ],
        ),
      ],
      errorBuilder: (context, state) => const LoadingView()
    );
  }
}
