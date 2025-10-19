import 'package:app/src/presentation/features/media/views/months_view.dart';
import 'package:app/src/presentation/features/media/views/sort_summary_view.dart';
import 'package:app/src/presentation/features/media/views/sort_swipe_view.dart';
import 'package:app/src/presentation/features/media/views/years_view.dart';
import 'package:app/src/presentation/features/settings/views/authorize_view.dart';
import 'package:app/src/presentation/features/settings/views/settings_list_view.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_state.dart';
import 'package:app/src/presentation/shared/views/loading_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _mediaNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'media');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

class AppRouter {
  static const root = '/';
  static const media = "/media";
  static const mediaForYear = "/media/:year";
  static const sortSwipe = "/media/:year/:month/swipe";
  static const sortSummary = "/media/:year/:month/summary";
  static const settings = "/settings";
  static const authorize = "/authorize";

  static GoRouter setupRoutes() {
    return GoRouter(
      initialLocation: root,
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: kDebugMode,
      routes: [
        GoRoute(
          path: AppRouter.root,
          name: AppRouter.root,
          redirect: (context, _) {
            final settingsCubit = context.read<SettingsCubit>();
            final state = settingsCubit.state;

            if (state is SettingsLoaded) {
              if (!state.settings.hasPhotosAccess) {
                return AppRouter.authorize;
              }
              return AppRouter.media;
            }
            return AppRouter.media;
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, child) {
            return child;
          },
          branches: [_setupMediaBranch(), _setupSettingsBranch()],
        ),
      ],
      errorBuilder: (context, state) => const LoadingView(),
    );
  }

  static StatefulShellBranch _setupMediaBranch() {
    return StatefulShellBranch(
      initialLocation: AppRouter.media,
      navigatorKey: _mediaNavigatorKey,
      routes: [
        GoRoute(
          name: AppRouter.media,
          path: AppRouter.media,
          pageBuilder: (context, state) =>
              MaterialPage(child: YearsView(key: state.pageKey)),
          routes: [
            GoRoute(
              name: AppRouter.mediaForYear,
              path: AppRouter.mediaForYear.substring(
                AppRouter.media.length + 1,
              ),
              pageBuilder: (context, state) => MaterialPage(
                child: MonthsView(
                  key: state.pageKey,
                  year: int.parse(state.pathParameters['year']!),
                ),
              ),
              routes: [
                GoRoute(
                  name: AppRouter.sortSwipe,
                  path: AppRouter.sortSwipe.substring(
                    AppRouter.mediaForYear.length + 1,
                  ),
                  pageBuilder: (context, state) => MaterialPage(
                    child: SortSwipeView(
                      year: int.parse(state.pathParameters['year']!),
                      month: int.parse(state.pathParameters['month']!),
                      mode: state.uri.queryParameters['mode'],
                    ),
                  ),
                ),
                GoRoute(
                  name: AppRouter.sortSummary,
                  path: AppRouter.sortSummary.substring(
                    AppRouter.mediaForYear.length + 1,
                  ),
                  pageBuilder: (context, state) => MaterialPage(
                    child: SortSummaryView(
                      year: int.parse(state.pathParameters['year']!),
                      month: int.parse(state.pathParameters['month']!),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static StatefulShellBranch _setupSettingsBranch() {
    return StatefulShellBranch(
      initialLocation: AppRouter.settings,
      navigatorKey: _settingsNavigatorKey,
      routes: [
        GoRoute(
          name: AppRouter.settings,
          path: AppRouter.settings,
          pageBuilder: (context, state) =>
              MaterialPage(child: SettingsListView(key: state.pageKey)),
        ),
        GoRoute(
          path: AppRouter.authorize,
          name: AppRouter.authorize,
          pageBuilder: (context, state) =>
              MaterialPage(child: AuthorizeView(key: state.pageKey)),
        ),
      ],
    );
  }
}
