import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/views/assets_by_yearmonth_view.dart';
import 'package:sortmaster_photos/src/views/assets_summary_view.dart';
import 'package:sortmaster_photos/src/views/home_view.dart';
import 'package:sortmaster_photos/src/views/loading_view.dart';
import 'package:sortmaster_photos/src/views/onboarding_view.dart';
import 'package:sortmaster_photos/src/views/permissions_view.dart';
import 'package:sortmaster_photos/src/views/plans_view.dart';
import 'package:sortmaster_photos/src/views/settings_view.dart';

GoRouter setupRoutes()  {
  // SettingsController controller = di<SettingsController>();
  String initialLocation = '/home';
  // controller.selector == LoaderSelector.Loading ? '/loading'
  //     : controller.selector == LoaderSelector.Onboarding ? '/onboarding'
  //     : controller.selector == LoaderSelector.Subscription ? '/plans'
  //     : controller.selector == LoaderSelector.Permissions ? '/permissions'
  //     : controller.selector == LoaderSelector.Home ? '/home'
  //     : '/loading';

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingView(),
      ),
      GoRoute(
        path: '/plans',
        builder: (context, state) => PlansView(),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => PermissionsView(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        path: '/assets/sort/:year/:month',
        name: 'assetsByYearMonth',
        builder: (context, state) => AssetsByYearMonthView(
          year: int.parse(state.pathParameters['year']!),
          month: int.parse(state.pathParameters['month']!),
        ),
      ),
      GoRoute(
        path: '/assets/summary',
        builder: (context, state) => AssetsSummaryView(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsView(),
      ),
    ],
  );
}