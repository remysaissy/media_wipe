import 'package:app/src/models/asset.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/models/datastore.dart';
import 'package:app/src/models/session.dart';
import 'package:app/src/models/sessions_model.dart';
import 'package:app/src/models/settings.dart';
import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/src/app.dart';
import 'package:app/src/services/app_service.dart';
import 'package:app/src/services/assets_service.dart';
import 'package:app/src/services/in_app_review_service.dart';
import 'package:app/src/services/settings_service.dart';
import 'package:app/src/services/subscriptions_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final instance = await Datastore.getInstance();

  runApp(
    MultiProvider(
      providers: [
        /// MODELS
        ChangeNotifierProvider.value(
            value: await SettingsModel(instance.store.box<Settings>()).load()),
        ChangeNotifierProvider.value(
            value: await AssetsModel(instance.store.box<Asset>()).load()),
        ChangeNotifierProvider.value(
            value: await SessionsModel(instance.store.box<Session>()).load()),

        /// SERVICES
        Provider(create: (_) => AppService()),
        Provider(create: (_) => InAppReviewsService()),
        Provider(create: (_) => SettingsService()),
        Provider(create: (_) => SubscriptionsService()),
        Provider(create: (_) => AssetsService()),

        /// ROOT CONTEXT, Allows Commands to retrieve a 'safe' context that is not tied to any one view. Allows them to work on async tasks without issues.
        Provider<BuildContext>(create: (c) => c),
      ],
      child: const MyApp(),
    ),
  );
}
