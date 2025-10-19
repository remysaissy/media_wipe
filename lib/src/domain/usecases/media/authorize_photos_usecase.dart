import 'package:app/src/data/datasources/asset_local_datasource.dart';

class AuthorizePhotosUseCase {
  final AssetLocalDataSource _dataSource;

  AuthorizePhotosUseCase(this._dataSource);

  Future<void> execute() async {
    await _dataSource.authorizePhotos();
  }

  Future<bool> isAuthorized() async {
    return await _dataSource.isPhotosAuthorized();
  }
}
