import 'package:app/src/domain/entities/asset.dart';

abstract class AssetRepository {
  Future<List<Asset>> getAssets();
  Future<Asset?> getAssetById(int id);
  Future<Asset?> getAssetByAssetId(String assetId);
  Future<List<Asset>> getAssetsByYear(int year);
  Future<List<Asset>> getAssetsByYearAndMonth(int year, int month);
  Future<List<int>> addAssets(List<Asset> assets);
  Future<void> updateAssets(List<Asset> assets);
  Future<void> deleteAssets(List<int> ids);
  Future<void> deleteAssetsByYear(int year);
  Future<void> deleteAssetsByYearAndMonth(int year, int month);
  Future<List<String>> deleteAssetsFromDevice({
    required List<String> assetIds,
    required bool isDry,
  });
  Future<List<Asset>> refreshPhotosFromDevice({required int year});
}
