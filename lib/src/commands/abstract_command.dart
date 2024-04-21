import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:sortmaster_photos/src/services/assets_service.dart';
import 'package:sortmaster_photos/src/services/permissions_service.dart';
import 'package:sortmaster_photos/src/services/subscriptions_service.dart';

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
  SettingsModel get settingsModel => getProvided();
  AssetsModel get assetsModel => getProvided();
  SessionsModel get sessionsModel => getProvided();

  /// Services
  PermissionsService get permissionsService => getProvided();
  SubscriptionsService get subscriptionsService => getProvided();
  AssetsService get assetsService => getProvided();
}