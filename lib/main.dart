import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:app/src/app.dart';
import 'package:app/src/models/app_model.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/models/sessions_model.dart';
import 'package:app/src/models/settings_model.dart';
import 'package:app/src/services/app_service.dart';
import 'package:app/src/services/assets_service.dart';
import 'package:app/src/services/in_app_review_service.dart';
import 'package:app/src/services/permissions_service.dart';
import 'package:app/src/services/subscriptions_service.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final appModel = await AppModel().load() as AppModel;
  final settingsModel = await SettingsModel().load() as SettingsModel;
  final assetsModel = await AssetsModel().load() as AssetsModel;
  final sessionsModel = await SessionsModel().load() as SessionsModel;
  runApp(
    MultiProvider(
      providers: [
        /// MODELS
        ChangeNotifierProvider.value(value: appModel),
        ChangeNotifierProvider.value(value: settingsModel),
        ChangeNotifierProvider.value(value: assetsModel),
        ChangeNotifierProvider.value(value: sessionsModel),

        /// SERVICES
        Provider(create: (_) => AppService()),
        Provider(create: (_) => InAppReviewsService()),
        Provider(create: (_) => PermissionsService()),
        Provider(create: (_) => SubscriptionsService()),
        Provider(create: (_) => AssetsService()),

        /// ROOT CONTEXT, Allows Commands to retrieve a 'safe' context that is not tied to any one view. Allows them to work on async tasks without issues.
        Provider<BuildContext>(create: (c) => c),
      ],
      child: const MyApp(),
    ),
  );
}
