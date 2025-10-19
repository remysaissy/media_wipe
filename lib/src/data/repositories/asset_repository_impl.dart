import 'package:app/src/data/datasources/asset_local_datasource.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetLocalDataSource _dataSource;

  AssetRepositoryImpl(this._dataSource);

  // Mappers
  Asset _entityToDomain(AssetEntity entity) {
    return Asset(
      id: entity.id,
      assetId: entity.assetId,
      creationDate: entity.creationDate,
    );
  }

  AssetEntity _domainToEntity(Asset domain) {
    return AssetEntity(
      id: domain.id,
      assetId: domain.assetId,
      creationDate: domain.creationDate,
    );
  }

  @override
  Future<List<Asset>> getAssets() async {
    final entities = await _dataSource.getAllAssets();
    return entities.map(_entityToDomain).toList();
  }

  @override
  Future<Asset?> getAssetById(int id) async {
    final entity = await _dataSource.getAssetById(id);
    return entity != null ? _entityToDomain(entity) : null;
  }

  @override
  Future<Asset?> getAssetByAssetId(String assetId) async {
    final entity = await _dataSource.getAssetByAssetId(assetId);
    return entity != null ? _entityToDomain(entity) : null;
  }

  @override
  Future<List<Asset>> getAssetsByYear(int year) async {
    final entities = await _dataSource.getAssetsByYear(year);
    return entities.map(_entityToDomain).toList();
  }

  @override
  Future<List<Asset>> getAssetsByYearAndMonth(int year, int month) async {
    final entities = await _dataSource.getAssetsByYearAndMonth(year, month);
    return entities.map(_entityToDomain).toList();
  }

  @override
  Future<List<int>> addAssets(List<Asset> assets) async {
    final entities = assets.map(_domainToEntity).toList();
    return await _dataSource.addAssets(entities);
  }

  @override
  Future<void> updateAssets(List<Asset> assets) async {
    final entities = assets.map(_domainToEntity).toList();
    await _dataSource.updateAssets(entities);
  }

  @override
  Future<void> deleteAssets(List<int> ids) async {
    await _dataSource.deleteAssets(ids);
  }

  @override
  Future<void> deleteAssetsByYear(int year) async {
    await _dataSource.deleteAssetsByYear(year);
  }

  @override
  Future<void> deleteAssetsByYearAndMonth(int year, int month) async {
    await _dataSource.deleteAssetsByYearAndMonth(year, month);
  }

  @override
  Future<List<String>> deleteAssetsFromDevice({
    required List<String> assetIds,
    required bool isDry,
  }) async {
    return await _dataSource.deleteAssetsFromDevice(
      assetIds: assetIds,
      isDry: isDry,
    );
  }

  @override
  Future<List<Asset>> refreshPhotosFromDevice({required int year}) async {
    final entities = await _dataSource.listDeviceAssets(year: year);
    return entities.map(_entityToDomain).toList();
  }
}
