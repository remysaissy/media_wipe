import 'package:app/src/data/datasources/settings_local_datasource.dart';
import 'package:app/src/data/local/models/settings_entity.dart';
import 'package:app/src/domain/entities/settings.dart';
import 'package:app/src/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  // Mappers
  Settings _entityToDomain(SettingsEntity entity) {
    return Settings(
      id: entity.id,
      themeMode: entity.themeMode,
      hasPhotosAccess: entity.hasPhotosAccess,
      hasInAppReview: entity.hasInAppReview,
      debugDryRemoval: entity.debugDryRemoval,
    );
  }

  SettingsEntity _domainToEntity(Settings domain) {
    return SettingsEntity(
      id: domain.id,
      themeMode: domain.themeMode,
      hasPhotosAccess: domain.hasPhotosAccess,
      hasInAppReview: domain.hasInAppReview,
      debugDryRemoval: domain.debugDryRemoval,
    );
  }

  @override
  Future<Settings> getSettings() async {
    final entity = await _dataSource.getOrCreateSettings();
    return _entityToDomain(entity);
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    final entity = _domainToEntity(settings);
    await _dataSource.updateSettings(entity);
  }
}
