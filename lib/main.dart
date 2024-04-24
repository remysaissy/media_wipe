import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/app.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:sortmaster_photos/src/services/assets_service.dart';
import 'package:sortmaster_photos/src/services/in_app_review_service.dart';
import 'package:sortmaster_photos/src/services/permissions_service.dart';
import 'package:sortmaster_photos/src/services/subscriptions_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsModel = SettingsModel();
  final assetsModel = AssetsModel();
  final sessionsModel = SessionsModel();
  runApp(
    MultiProvider(
      providers: [
        /// MODELS
        ChangeNotifierProvider.value(value: settingsModel),
        ChangeNotifierProvider.value(value: assetsModel),
        ChangeNotifierProvider.value(value: sessionsModel),

        /// SERVICES
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
