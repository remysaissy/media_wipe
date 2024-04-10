import 'package:sortmaster_photos/src/home/home_view.dart';
import 'package:sortmaster_photos/src/ioc.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/plans/plans_view.dart';
import 'package:sortmaster_photos/src/settings/settings_controller.dart';
import 'package:sortmaster_photos/src/settings/settings_view.dart';
import 'package:sortmaster_photos/src/theme.dart';

class MyApp extends StatefulWidget{
  late final GoRouter router;

  MyApp({
    super.key
  }) {
    // GoRouter configuration
    router = GoRouter(
      initialLocation: getIt<SettingsController>().isOnboarded ? '/plans' : '/onboarding',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeView(),
        ),
        GoRoute(
          path: '/plans',
          builder: (context, state) => PlansView(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingView(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsView(),
        ),
      ],
    );
  }

  @override
  State <StatefulWidget> createState () => _MyAppState();
}

/// The Widget that configures your application.
class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: getIt<SettingsController>(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: MyTheme.light(),
          darkTheme: MyTheme.dark(),
          themeMode: getIt<SettingsController>().themeMode,

          // Define routes available in the application.
          routerConfig: widget.router,
        );
      },
    );
  }
}
