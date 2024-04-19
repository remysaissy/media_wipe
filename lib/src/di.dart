import 'package:get_it/get_it.dart';
import 'package:sortmaster_photos/src/controllers/assets_controller.dart';
import 'package:sortmaster_photos/src/controllers/home_controller.dart';
import 'package:sortmaster_photos/src/services/assets_service.dart';
import 'package:sortmaster_photos/src/controllers/onboarding_controller.dart';
import 'package:sortmaster_photos/src/services/db_service.dart';
import 'package:sortmaster_photos/src/services/onboarding_service.dart';
import 'package:sortmaster_photos/src/controllers/permissions_controller.dart';
import 'package:sortmaster_photos/src/services/permissions_service.dart';
import 'package:sortmaster_photos/src/controllers/plans_controller.dart';
import 'package:sortmaster_photos/src/services/plans_service.dart';
import 'package:sortmaster_photos/src/controllers/settings_controller.dart';
import 'package:sortmaster_photos/src/services/sessions_service.dart';
import 'package:sortmaster_photos/src/services/settings_service.dart';

final di = GetIt.instance;

void _setupServices() {
  di.registerSingletonAsync<DBService>(() async => DBService().init());
  di.registerSingletonAsync<SettingsService>(() async => SettingsService().init());
  di.registerSingletonAsync<OnboardingService>(() async => OnboardingService().init());
  di.registerSingletonAsync<PlansService>(() async => PlansService().init());
  di.registerSingletonAsync<PermissionsService>(() async => PermissionsService());
  di.registerSingletonAsync<AssetsService>(() async => AssetsService().init(), dependsOn: [DBService]);
  di.registerSingletonAsync<SessionsService>(() async => SessionsService().init(), dependsOn: [DBService]);
}

void _setupControllers() {
  di.registerSingletonAsync<SettingsController>(() async => SettingsController().init(), dependsOn: [SettingsService]);
  di.registerSingletonWithDependencies<OnboardingController>(() => OnboardingController(), dependsOn: [OnboardingService]);
  di.registerSingletonWithDependencies<PlansController>(() => PlansController(), dependsOn: [PlansService]);
  di.registerSingletonWithDependencies<PermissionsController>(() => PermissionsController(), dependsOn: [PermissionsService]);
  di.registerSingletonWithDependencies<HomeController>(() => HomeController(), dependsOn: [AssetsService]);
  di.registerSingletonWithDependencies<AssetsController>(() => AssetsController(), dependsOn: [AssetsService]);
}

void setupDI() {
  _setupServices();
  _setupControllers();
}