import 'dart:io';
import 'package:isar/isar.dart';
import 'package:app/src/data/datasources/session_local_datasource.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/data/local/models/session_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Isar isar;
  late SessionLocalDataSource dataSource;
  late Directory testDir;

  setUp(() async {
    // Create temporary directory for test database
    testDir = Directory.systemTemp.createTempSync('isar_test_');

    // Create Isar instance for testing
    isar = await Isar.open(
      [AssetEntitySchema, SessionEntitySchema],
      directory: testDir.path,
      name: 'test_db_${DateTime.now().millisecondsSinceEpoch}',
    );
    dataSource = SessionLocalDataSource(isar);
  });

  tearDown(() async {
    await isar.close();
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
  });

  group('SessionLocalDataSource', () {
    SessionEntity createTestSession({int year = 2024, int month = 1}) {
      return SessionEntity(sessionYear: year, sessionMonth: month);
    }

    group('getAllSessions', () {
      test('should return empty list when no sessions exist', () async {
        // Act
        final result = await dataSource.getAllSessions();

        // Assert
        expect(result, isEmpty);
      });

      test('should return all sessions from box', () async {
        // Arrange
        await dataSource.createSession(createTestSession(year: 2024, month: 1));
        await dataSource.createSession(createTestSession(year: 2024, month: 2));

        // Act
        final result = await dataSource.getAllSessions();

        // Assert
        expect(result.length, 2);
      });
    });

    group('getSessionById', () {
      test('should return session when found by ID', () async {
        // Arrange
        final id = await dataSource.createSession(createTestSession());

        // Act
        final result = await dataSource.getSessionById(id);

        // Assert
        expect(result, isNotNull);
        expect(result!.id, id);
        expect(result.sessionYear, 2024);
      });

      test('should return null when session not found', () async {
        // Act
        final result = await dataSource.getSessionById(999);

        // Assert
        expect(result, isNull);
      });
    });

    group('getActiveSession', () {
      test('should return first session as active', () async {
        // Arrange
        await dataSource.createSession(createTestSession(year: 2024, month: 1));
        await dataSource.createSession(createTestSession(year: 2024, month: 2));

        // Act
        final result = await dataSource.getActiveSession();

        // Assert
        expect(result, isNotNull);
        expect(result!.sessionYear, 2024);
      });

      test('should return null when no sessions exist', () async {
        // Act
        final result = await dataSource.getActiveSession();

        // Assert
        expect(result, isNull);
      });
    });

    group('createSession', () {
      test('should create session and return generated ID', () async {
        // Arrange
        final session = createTestSession();

        // Act
        final id = await dataSource.createSession(session);

        // Assert
        expect(id, greaterThan(0));

        final retrieved = await dataSource.getSessionById(id);
        expect(retrieved, isNotNull);
        expect(retrieved!.sessionYear, 2024);
        expect(retrieved.sessionMonth, 1);
      });

      test('should create session with IsarLinks relations', () async {
        // Arrange
        final asset = AssetEntity(
          assetId: 'asset1',
          creationDate: DateTime(2024, 1, 15),
        );
        await isar.writeTxn(() async {
          await isar.assetEntitys.put(asset);
        });

        final session = createTestSession();
        session.assetsToDrop.add(asset);

        // Act
        final id = await dataSource.createSession(session);

        // Assert
        final retrieved = await dataSource.getSessionById(id);
        expect(retrieved!.assetsToDrop.length, 1);
        expect(retrieved.assetsToDrop.first.assetId, 'asset1');
      });
    });

    group('updateSession', () {
      test('should update existing session', () async {
        // Arrange
        final session = createTestSession(year: 2024, month: 1);
        final id = await dataSource.createSession(session);
        final retrieved = await dataSource.getSessionById(id);
        retrieved!.sessionMonth = 6;

        // Act
        await dataSource.updateSession(retrieved);

        // Assert
        final updated = await dataSource.getSessionById(id);
        expect(updated!.sessionMonth, 6);
      });
    });

    group('deleteSession', () {
      test('should delete session by ID', () async {
        // Arrange
        final id = await dataSource.createSession(createTestSession());

        // Act
        await dataSource.deleteSession(id);

        // Assert
        final deleted = await dataSource.getSessionById(id);
        expect(deleted, isNull);
      });

      test('should only delete specified session', () async {
        // Arrange
        final id1 = await dataSource.createSession(createTestSession(month: 1));
        final id2 = await dataSource.createSession(createTestSession(month: 2));

        // Act
        await dataSource.deleteSession(id1);

        // Assert
        final all = await dataSource.getAllSessions();
        expect(all.length, 1);
        expect(all[0].id, id2);
      });
    });

    group('deleteAllSessions', () {
      test('should delete all sessions', () async {
        // Arrange
        await dataSource.createSession(createTestSession(month: 1));
        await dataSource.createSession(createTestSession(month: 2));
        await dataSource.createSession(createTestSession(month: 3));

        // Act
        await dataSource.deleteAllSessions();

        // Assert
        final all = await dataSource.getAllSessions();
        expect(all, isEmpty);
      });

      test('should handle deleting when no sessions exist', () async {
        // Act & Assert
        await dataSource.deleteAllSessions();
        final all = await dataSource.getAllSessions();
        expect(all, isEmpty);
      });
    });

    group('relations', () {
      test('should persist IsarLinks assetsToDrop relation', () async {
        // Arrange
        final asset1 = AssetEntity(
          assetId: 'asset1',
          creationDate: DateTime(2024, 1, 15),
        );
        final asset2 = AssetEntity(
          assetId: 'asset2',
          creationDate: DateTime(2024, 1, 20),
        );
        await isar.writeTxn(() async {
          await isar.assetEntitys.putAll([asset1, asset2]);
        });

        final session = createTestSession();
        session.assetsToDrop.addAll([asset1, asset2]);
        final id = await dataSource.createSession(session);

        // Act
        final retrieved = await dataSource.getSessionById(id);

        // Assert
        expect(retrieved!.assetsToDrop.length, 2);
      });

      test('should persist ToOne assetInReview relation', () async {
        // Arrange
        final asset = AssetEntity(
          assetId: 'asset1',
          creationDate: DateTime(2024, 1, 15),
        );
        await isar.writeTxn(() async {
          await isar.assetEntitys.put(asset);
        });

        final session = createTestSession();
        session.assetInReview.value = asset;
        final id = await dataSource.createSession(session);

        // Act
        final retrieved = await dataSource.getSessionById(id);

        // Assert
        expect(retrieved!.assetInReview.value, isNotNull);
        expect(retrieved.assetInReview.value!.assetId, 'asset1');
      });
    });
  });
}
