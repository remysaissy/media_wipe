import 'package:app/src/models/assets_model.dart';
import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/src/models/app_model.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/models/settings42_model.dart';
import 'package:app/src/services/app_service.dart';
import 'package:app/src/services/assets_service.dart';
import 'package:app/src/services/in_app_review_service.dart';
import 'package:app/src/services/permissions_service.dart';
import 'package:app/src/services/subscriptions_service.dart';

abstract class AbstractCommand {
  static BuildContext? _lastKnownRoot;

  /// Provide all commands access to the global context & navigator
  late BuildContext context;

  AbstractCommand(BuildContext c) {
    /// Get root context
    /// If we're passed a context that is known to be root, skip the lookup, it will throw an error otherwise.
    context = (c == _lastKnownRoot) ? c : Provider.of(c, listen: false);
    _lastKnownRoot = context;
  }

  T getProvided<T>() => Provider.of<T>(context, listen: false);

  /// Convenience lookup methods for all commands to share
  ///
  /// Models
  AppModel get appModel => getProvided();

  Settings42Model get settings42Model => getProvided();

  SettingsModel get settingsModel => getProvided();

  AssetsModel get assetsModel => getProvided();

  /// Services
  AppService get appService => getProvided();

  InAppReviewsService get inAppReviewsService => getProvided();

  PermissionsService get permissionsService => getProvided();

  SubscriptionsService get subscriptionsService => getProvided();

  AssetsService get assetsService => getProvided();
}
