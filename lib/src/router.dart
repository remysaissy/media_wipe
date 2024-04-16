import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/assets/assets_view.dart';
import 'package:sortmaster_photos/src/home/home_view.dart';
import 'package:sortmaster_photos/src/loader/loading_view.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_view.dart';
import 'package:sortmaster_photos/src/permissions/permissions_view.dart';
import 'package:sortmaster_photos/src/plans/plans_view.dart';
import 'package:sortmaster_photos/src/settings/settings_view.dart';

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
        path: '/assets/yearmonth/:year/:month',
        name: 'assetsByYearMonth',
        builder: (context, state) => AssetsView(
          assetsViewMode: AssetsViewMode.YearMonth,
          year: int.parse(state.pathParameters['year']!),
          month: int.parse(state.pathParameters['month']!),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsView(),
      ),
    ],
  );
}