import 'package:app/src/models/asset.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/models/datastore.dart';
import 'package:app/src/models/settings.dart';
import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:app/src/app.dart';
import 'package:app/src/models/app_model.dart';
import 'package:app/src/models/settings42_model.dart';
import 'package:app/src/services/app_service.dart';
import 'package:app/src/services/assets_service.dart';
import 'package:app/src/services/in_app_review_service.dart';
import 'package:app/src/services/permissions_service.dart';
import 'package:app/src/services/subscriptions_service.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final instance = await Datastore.getInstance();
  final appModel = await AppModel().load() as AppModel;
  final settings42Model = await Settings42Model().load() as Settings42Model;
  runApp(
    MultiProvider(
      providers: [
        /// MODELS
        ChangeNotifierProvider.value(value: appModel),
        ChangeNotifierProvider.value(value: settings42Model),
        ChangeNotifierProvider.value(
            value: await SettingsModel(instance.store.box<Settings>()).load()
                as SettingsModel),
        ChangeNotifierProvider.value(
            value: await AssetsModel(instance.store.box<Asset>()).load()
                as AssetsModel),

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
