import 'package:get_it/get_it.dart';
import 'package:sortmaster_photos/src/home/home_controller.dart';
import 'package:sortmaster_photos/src/home/assets_service.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_controller.dart';
import 'package:sortmaster_photos/src/onboarding/onboarding_service.dart';
import 'package:sortmaster_photos/src/permissions/permissions_controller.dart';
import 'package:sortmaster_photos/src/permissions/permissions_service.dart';
import 'package:sortmaster_photos/src/plans/plans_controller.dart';
import 'package:sortmaster_photos/src/plans/plans_service.dart';
import 'package:sortmaster_photos/src/settings/settings_controller.dart';
import 'package:sortmaster_photos/src/settings/settings_service.dart';

final di = GetIt.instance;

Future<void> setupDI() async {
  // Services
  di.registerSingleton(SettingsService());
  di.registerSingleton(OnboardingService());
  di.registerSingleton(PlansService());
  di.registerSingleton(PermissionsService());
  di.registerSingleton(AssetsService());

  // Controllers
  di.registerSingleton(SettingsController());
  di.registerSingleton(OnboardingController());
  di.registerSingleton(PlansController());
  di.registerSingleton(PermissionsController());
  di.registerSingleton(HomeController());

  // Load time methods required for some services or controllers
  await di<SettingsController>().load();
  await di<AssetsService>().load();
}