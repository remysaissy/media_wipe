import 'package:go_router/go_router.dart';
import 'package:app/src/views/authorize_view.dart';
import 'package:app/src/views/listing/months_view.dart';
import 'package:app/src/views/sorting/sort_photos_view.dart';
import 'package:app/src/views/sorting/sort_photos_summary_view.dart';
import 'package:app/src/views/listing/years_view.dart';
import 'package:app/src/views/onboarding/onboarding_view.dart';
import 'package:app/src/views/routing_view.dart';
import 'package:app/src/views/settings/settings_view.dart';
import 'package:app/src/views/subscriptions/subscriptions_view.dart';

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
        path: '/authorize',
        builder: (context, state) => const AuthorizeView(),
      ),
      GoRoute(
        path: '/photos',
        name: 'listYears',
        builder: (context, state) => const YearsView(),
      ),
      GoRoute(
        path: '/photos/:year',
        name: 'listMonths',
        builder: (context, state) => MonthsView(
          year: int.parse(state.pathParameters['year']!),
        ),
      ),
      GoRoute(
          path: '/sort/:year/:month/:mode',
          name: 'sortPhotos',
          builder: (context, state) => SortPhotosView(
              year: int.parse(state.pathParameters['year']!),
              month: int.parse(state.pathParameters['month']!),
              mode: state.pathParameters['mode']!)),
      GoRoute(
        path: '/summary/:year/:month',
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
