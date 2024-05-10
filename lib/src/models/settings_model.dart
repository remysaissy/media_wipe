import 'package:app/src/models/settings.dart';
import 'package:app/src/services/assets_service.dart';
import 'package:app/src/services/subscriptions_service.dart';
import 'package:flutter/widgets.dart';
import 'package:objectbox/objectbox.dart';

class SettingsModel extends ChangeNotifier {
  final Box<Settings> _settingsBox;

  SettingsModel(this._settingsBox);

  Settings? _settings;

  /// Use for initial loading.
  Future<SettingsModel> load() async {
    await fetchSettings();
    _settings?.hasPhotosAccess =
    await AssetsService().isPhotosAuthorized();
    _settings?.hasInAppReview = await SubscriptionsService().isInAppReviewAvailable();
    await updateSettings();
    return this;
  }

  /// Pivotal method to fetch the up to date settings from storage.
  Future<void> fetchSettings() async {
    _settings = _settingsBox.getAll().firstOrNull;
    if (_settings == null) {
      _settings = Settings();
      _settings?.id =
          await _settingsBox.putAsync(_settings!, mode: PutMode.insert);
    }
    notifyListeners();
  }

  /// The fetchSettings, called by the initial load guarantee it exists.
  Settings get settings => _settings!;

  Future<void> updateSettings() async {
    await _settingsBox.putAsync(settings, mode: PutMode.update);
    await fetchSettings();
  }
}
