import 'package:get_it/get_it.dart';
import 'package:sortmaster_photos/src/assets/assets_controller.dart';
import 'package:sortmaster_photos/src/home/home_controller.dart';
import 'package:sortmaster_photos/src/assets/assets_service.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_controller.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_service.dart';
import 'package:sortmaster_photos/src/permissions/permissions_controller.dart';
import 'package:sortmaster_photos/src/permissions/permissions_service.dart';
import 'package:sortmaster_photos/src/plans/plans_controller.dart';
import 'package:sortmaster_photos/src/plans/plans_service.dart';
import 'package:sortmaster_photos/src/settings/settings_controller.dart';
import 'package:sortmaster_photos/src/settings/settings_service.dart';

final di = GetIt.instance;

void _setupServices() {
  di.registerSingletonAsync<SettingsService>(() async {
    final service = SettingsService();
    await service.init();
    return service;
  });
  di.registerSingletonAsync<OnboardingService>(() async {
    final service = OnboardingService();
    await service.init();
    return service;
  });
  di.registerSingletonAsync<PlansService>(() async {
    final service = PlansService();
    await service.init();
    return service;
  });
  di.registerSingletonAsync<PermissionsService>(() async {
    return PermissionsService();
  });
  di.registerSingletonAsync<AssetsService>(() async {
    final service = AssetsService();
    await service.init();
    return service;
  });
}

void _setupControllers() {
  di.registerSingletonAsync<SettingsController>(() async {
    final service = SettingsController();
    await service.init();
    return service;
  }, dependsOn: [SettingsService]);
  di.registerSingletonWithDependencies<OnboardingController>(() {
    return OnboardingController();
  }, dependsOn: [OnboardingService]);
  di.registerSingletonWithDependencies<PlansController>(() {
    return PlansController();
  }, dependsOn: [PlansService]);
  di.registerSingletonWithDependencies<PermissionsController>(() {
    return PermissionsController();
  }, dependsOn: [PermissionsService]);
  di.registerSingletonWithDependencies<HomeController>(() {
    return HomeController();
  }, dependsOn: [AssetsService]);
  di.registerSingletonWithDependencies<AssetsController>(() {
    return AssetsController();
  }, dependsOn: [AssetsService]);
}

void setupDI() {
  _setupServices();
  _setupControllers();
}