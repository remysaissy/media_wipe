import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/views/list_months_view.dart';
import 'package:sortmaster_photos/src/views/sort_photos_view.dart';
import 'package:sortmaster_photos/src/views/sort_photos_summary_view.dart';
import 'package:sortmaster_photos/src/views/list_years_view.dart';
import 'package:sortmaster_photos/src/views/onboarding_view.dart';
import 'package:sortmaster_photos/src/views/routing_view.dart';
import 'package:sortmaster_photos/src/views/settings_view.dart';
import 'package:sortmaster_photos/src/views/subscriptions_view.dart';

GoRouter setupRoutes() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RoutingView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/subscriptions',
        builder: (context, state) => const SubscriptionsView(),
      ),
      GoRoute(
        path: '/photos',
        name: 'listYears',
        builder: (context, state) => const ListYearsView(),
      ),
      GoRoute(
        path: '/photos/:year',
        name: 'listMonths',
        builder: (context, state) => ListMonthsView(
          year: int.parse(state.pathParameters['year']!),
        ),
      ),
      GoRoute(
        path: '/photos/:year/:month/sort',
        name: 'sortPhotos',
        builder: (context, state) => SortPhotosView(
          year: int.parse(state.pathParameters['year']!),
          month: int.parse(state.pathParameters['month']!),
        ),
      ),
      GoRoute(
        path: '/photos/:year/:month/summary',
        name: 'sortPhotosSummary',
        builder: (context, state) => SortPhotosSummaryView(
          year: int.parse(state.pathParameters['year']!),
          month: int.parse(state.pathParameters['month']!),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}
