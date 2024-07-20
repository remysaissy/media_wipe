import 'package:app/assets/views/months_view.dart';
import 'package:app/assets/views/sort_summary_view.dart';
import 'package:app/assets/views/years_view.dart';
import 'package:app/assets/views/sort_swipe_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _listingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'media');

class AssetsRouter {
  static const list = "/media";
  static const listForYear = "/media/:year";
  static const sortSwipe = "/media/:year/:month/swipe";
  static const sortSummary = "/media/:year/:month/summary";

  static StatefulShellBranch setup() {
    return StatefulShellBranch(
      initialLocation: AssetsRouter.list,
      navigatorKey: _listingNavigatorKey,
      routes: [
        GoRoute(
          name: AssetsRouter.list,
          path: AssetsRouter.list,
          pageBuilder: (context, state) => MaterialPage(
            child: ListYearsView(key: state.pageKey),
          ),
          routes: [
            GoRoute(
              name: AssetsRouter.listForYear,
              path: AssetsRouter.listForYear
                  .substring(AssetsRouter.list.length + 1),
              pageBuilder: (context, state) => MaterialPage(
                child: ListMonthsView(
                    key: state.pageKey,
                    year: int.parse(state.pathParameters['year']!)),
              ),
              routes: [
                GoRoute(
                  name: AssetsRouter.sortSwipe,
                  path: AssetsRouter.sortSwipe
                      .substring(AssetsRouter.listForYear.length + 1),
                  pageBuilder: (context, state) => MaterialPage(
                    child: SortSwipe(
                        year: int.parse(state.pathParameters['year']!),
                        month: int.parse(state.pathParameters['month']!),
                        mode: state.uri.queryParameters['mode']),
                  ),
                ),
                GoRoute(
                  name: AssetsRouter.sortSummary,
                  path: AssetsRouter.sortSummary
                      .substring(AssetsRouter.listForYear.length + 1),
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
}
