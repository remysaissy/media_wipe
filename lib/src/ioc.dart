
import 'package:get_it/get_it.dart';
import 'package:sortmaster_photos/src/home/home_controller.dart';
import 'package:sortmaster_photos/src/plans/plans_controller.dart';
import 'package:sortmaster_photos/src/plans/plans_service.dart';
import 'package:sortmaster_photos/src/settings/settings_controller.dart';
import 'package:sortmaster_photos/src/settings/settings_service.dart';

final getIt = GetIt.instance;

void setup() {
  // Services
  getIt.registerSingleton(SettingsService());
  getIt.registerSingleton(PlansService());
  // Controllers
  getIt.registerSingleton(SettingsController());
  getIt.registerSingleton(PlansController());
  getIt.registerSingleton(HomeController());
}