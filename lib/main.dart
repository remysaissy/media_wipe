import 'package:app/assets/models/asset.dart';
import 'package:app/assets/models/asset_model.dart';
import 'package:app/shared/models/datastore.dart';
import 'package:app/assets/models/session.dart';
import 'package:app/assets/models/sessions_model.dart';
import 'package:app/settings/models/settings.dart';
import 'package:app/settings/models/settings_model.dart';
import 'package:app/shared/services/subscriptions_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/shared/app.dart';
import 'package:app/assets/services/assets_service.dart';

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
        Provider(create: (_) => AssetsService()),
        Provider(create: (_) => SubscriptionsService()),

        /// ROOT CONTEXT, Allows Commands to retrieve a 'safe' context that is not tied to any one view. Allows them to work on async tasks without issues.
        Provider<BuildContext>(create: (c) => c),
      ],
      child: const MyApp(),
    ),
  );
}
