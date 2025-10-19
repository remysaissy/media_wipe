import 'package:app/src/data/local/models/settings_entity.dart';
import 'package:isar/isar.dart';

class SettingsLocalDataSource {
  final Isar _isar;

  SettingsLocalDataSource(this._isar);

  Future<SettingsEntity?> getSettings() async {
    final all = await _isar.settingsEntitys.where().findAll();
    return all.isNotEmpty ? all.first : null;
  }

  Future<SettingsEntity> getOrCreateSettings() async {
    final existing = await getSettings();
    if (existing != null) {
      return existing;
    }

    final newSettings = SettingsEntity();
    await _isar.writeTxn(() async {
      await _isar.settingsEntitys.put(newSettings);
    });
    return newSettings;
  }

  Future<void> updateSettings(SettingsEntity settings) async {
    await _isar.writeTxn(() async {
      await _isar.settingsEntitys.put(settings);
    });
  }

  Future<void> createSettings(SettingsEntity settings) async {
    await _isar.writeTxn(() async {
      await _isar.settingsEntitys.put(settings);
    });
  }
}
