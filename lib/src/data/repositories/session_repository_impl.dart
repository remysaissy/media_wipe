import 'package:app/src/data/datasources/asset_local_datasource.dart';
import 'package:app/src/data/datasources/session_local_datasource.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/data/local/models/session_entity.dart';
import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/domain/entities/session.dart';
import 'package:app/src/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionLocalDataSource _dataSource;

  SessionRepositoryImpl(this._dataSource, AssetLocalDataSource assetDataSource);

  // Mappers
  Asset _assetEntityToDomain(AssetEntity entity) {
    return Asset(
      id: entity.id,
      assetId: entity.assetId,
      creationDate: entity.creationDate,
    );
  }

  AssetEntity _assetDomainToEntity(Asset domain) {
    return AssetEntity(
      id: domain.id,
      assetId: domain.assetId,
      creationDate: domain.creationDate,
    );
  }

  Session _entityToDomain(SessionEntity entity) {
    return Session(
      id: entity.id,
      assetsToDrop: entity.assetsToDrop.map(_assetEntityToDomain).toList(),
      refineAssetsToDrop: entity.refineAssetsToDrop
          .map(_assetEntityToDomain)
          .toList(),
      assetInReview: entity.assetInReview.value != null
          ? _assetEntityToDomain(entity.assetInReview.value!)
          : null,
      sessionYear: entity.sessionYear,
      sessionMonth: entity.sessionMonth,
    );
  }

  SessionEntity _domainToEntity(Session domain) {
    final entity = SessionEntity(
      id: domain.id,
      sessionYear: domain.sessionYear,
      sessionMonth: domain.sessionMonth,
    );

    // Add IsarLinks relations
    entity.assetsToDrop.addAll(domain.assetsToDrop.map(_assetDomainToEntity));
    entity.refineAssetsToDrop.addAll(
      domain.refineAssetsToDrop.map(_assetDomainToEntity),
    );

    // Set IsarLink relation
    if (domain.assetInReview != null) {
      entity.assetInReview.value = _assetDomainToEntity(domain.assetInReview!);
    }

    return entity;
  }

  @override
  Future<List<Session>> getAllSessions() async {
    final entities = await _dataSource.getAllSessions();
    return entities.map(_entityToDomain).toList();
  }

  @override
  Future<Session?> getSessionById(int id) async {
    final entity = await _dataSource.getSessionById(id);
    return entity != null ? _entityToDomain(entity) : null;
  }

  @override
  Future<Session?> getActiveSession() async {
    final entity = await _dataSource.getActiveSession();
    return entity != null ? _entityToDomain(entity) : null;
  }

  @override
  Future<int> createSession(Session session) async {
    final entity = _domainToEntity(session);
    return await _dataSource.createSession(entity);
  }

  @override
  Future<void> updateSession(Session session) async {
    final entity = _domainToEntity(session);
    await _dataSource.updateSession(entity);
  }

  @override
  Future<void> deleteSession(int id) async {
    await _dataSource.deleteSession(id);
  }

  @override
  Future<void> deleteAllSessions() async {
    await _dataSource.deleteAllSessions();
  }
}
