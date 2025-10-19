import 'dart:io';
import 'package:isar/isar.dart';
import 'package:app/src/data/datasources/asset_local_datasource.dart';
import 'package:app/src/data/datasources/session_local_datasource.dart';
import 'package:app/src/data/datasources/settings_local_datasource.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/data/local/models/session_entity.dart';
import 'package:app/src/data/local/models/settings_entity.dart';
import 'package:app/src/data/repositories/asset_repository_impl.dart';
import 'package:app/src/data/repositories/session_repository_impl.dart';
import 'package:app/src/data/repositories/settings_repository_impl.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';
import 'package:app/src/domain/repositories/session_repository.dart';
import 'package:app/src/domain/repositories/settings_repository.dart';
import 'package:app/src/domain/usecases/media/delete_assets_usecase.dart';
import 'package:app/src/domain/usecases/media/refresh_photos_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/commit_refine_in_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/drop_all_sessions_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/drop_asset_in_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/finish_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/keep_asset_in_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/start_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/undo_last_operation_usecase.dart';
import 'package:app/src/domain/usecases/settings/load_settings_usecase.dart';
import 'package:app/src/domain/usecases/settings/update_settings_usecase.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

/// Helper class for setting up integration tests with real dependencies
class IntegrationTestHelper {
  static Isar? _isar;
  static Directory? _testDir;
  static final getIt = GetIt.instance;

  /// Initialize the test environment with real Isar and dependencies
  static Future<void> setUp() async {
    // Create temporary directory for test database
    _testDir = Directory.systemTemp.createTempSync('isar_test_');

    // Create Isar instance for testing
    _isar = await Isar.open(
      [AssetEntitySchema, SessionEntitySchema, SettingsEntitySchema],
      directory: _testDir!.path,
      name: 'test_db_${DateTime.now().millisecondsSinceEpoch}',
    );

    // Register Isar
    getIt.registerSingleton<Isar>(_isar!);

    // Register data sources
    getIt.registerSingleton<AssetLocalDataSource>(AssetLocalDataSource(_isar!));
    getIt.registerSingleton<SessionLocalDataSource>(
      SessionLocalDataSource(_isar!),
    );
    getIt.registerSingleton<SettingsLocalDataSource>(
      SettingsLocalDataSource(_isar!),
    );

    // Register repositories
    getIt.registerSingleton<AssetRepository>(
      AssetRepositoryImpl(getIt<AssetLocalDataSource>()),
    );
    getIt.registerSingleton<SessionRepository>(
      SessionRepositoryImpl(
        getIt<SessionLocalDataSource>(),
        getIt<AssetLocalDataSource>(),
      ),
    );
    getIt.registerSingleton<SettingsRepository>(
      SettingsRepositoryImpl(getIt<SettingsLocalDataSource>()),
    );

    // Register use cases
    getIt.registerSingleton<RefreshPhotosUseCase>(
      RefreshPhotosUseCase(getIt<AssetRepository>()),
    );
    getIt.registerSingleton<DeleteAssetsUseCase>(
      DeleteAssetsUseCase(getIt<AssetRepository>()),
    );
    getIt.registerSingleton<StartSessionUseCase>(
      StartSessionUseCase(getIt<SessionRepository>(), getIt<AssetRepository>()),
    );
    getIt.registerSingleton<FinishSessionUseCase>(
      FinishSessionUseCase(getIt<SessionRepository>()),
    );
    getIt.registerSingleton<KeepAssetInSessionUseCase>(
      KeepAssetInSessionUseCase(
        getIt<SessionRepository>(),
        getIt<AssetRepository>(),
      ),
    );
    getIt.registerSingleton<DropAssetInSessionUseCase>(
      DropAssetInSessionUseCase(
        getIt<SessionRepository>(),
        getIt<AssetRepository>(),
      ),
    );
    getIt.registerSingleton<UndoLastOperationUseCase>(
      UndoLastOperationUseCase(getIt<SessionRepository>()),
    );
    getIt.registerSingleton<CommitRefineInSessionUseCase>(
      CommitRefineInSessionUseCase(getIt<SessionRepository>()),
    );
    getIt.registerSingleton<DropAllSessionsUseCase>(
      DropAllSessionsUseCase(getIt<SessionRepository>()),
    );
    getIt.registerSingleton<LoadSettingsUseCase>(
      LoadSettingsUseCase(getIt<SettingsRepository>()),
    );
    getIt.registerSingleton<UpdateSettingsUseCase>(
      UpdateSettingsUseCase(getIt<SettingsRepository>()),
    );

    // Register BLoCs/Cubits as factories
    getIt.registerFactory<MediaBloc>(
      () => MediaBloc(
        refreshPhotosUseCase: getIt<RefreshPhotosUseCase>(),
        deleteAssetsUseCase: getIt<DeleteAssetsUseCase>(),
        assetRepository: getIt<AssetRepository>(),
      ),
    );
    getIt.registerFactory<SessionCubit>(
      () => SessionCubit(
        startSessionUseCase: getIt<StartSessionUseCase>(),
        finishSessionUseCase: getIt<FinishSessionUseCase>(),
        keepAssetInSessionUseCase: getIt<KeepAssetInSessionUseCase>(),
        dropAssetInSessionUseCase: getIt<DropAssetInSessionUseCase>(),
        undoLastOperationUseCase: getIt<UndoLastOperationUseCase>(),
        commitRefineInSessionUseCase: getIt<CommitRefineInSessionUseCase>(),
        sessionRepository: getIt<SessionRepository>(),
      ),
    );
    getIt.registerFactory<SettingsCubit>(
      () => SettingsCubit(
        loadSettingsUseCase: getIt<LoadSettingsUseCase>(),
        updateSettingsUseCase: getIt<UpdateSettingsUseCase>(),
      ),
    );
  }

  /// Clean up the test environment
  static Future<void> tearDown() async {
    await getIt.reset();
    await _isar?.close();
    _isar = null;
    if (_testDir != null && _testDir!.existsSync()) {
      _testDir!.deleteSync(recursive: true);
    }
    _testDir = null;
  }

  /// Get a repository instance
  static T getRepository<T extends Object>() => getIt<T>();

  /// Get a use case instance
  static T getUseCase<T extends Object>() => getIt<T>();

  /// Get a BLoC instance
  static T getBloc<T extends Object>() => getIt<T>();

  /// Seed test data into the database
  static Future<void> seedTestData() async {
    final assetDataSource = getIt<AssetLocalDataSource>();

    // Create test assets across different years and months
    final testAssets = [
      AssetEntity(
        assetId: 'asset_2024_01_01',
        creationDate: DateTime(2024, 1, 15),
      ),
      AssetEntity(
        assetId: 'asset_2024_01_02',
        creationDate: DateTime(2024, 1, 20),
      ),
      AssetEntity(
        assetId: 'asset_2024_02_01',
        creationDate: DateTime(2024, 2, 10),
      ),
      AssetEntity(
        assetId: 'asset_2023_12_01',
        creationDate: DateTime(2023, 12, 25),
      ),
    ];

    await assetDataSource.addAssets(testAssets);
  }

  /// Clear all data from the database
  static Future<void> clearDatabase() async {
    final isar = getIt<Isar>();
    await isar.writeTxn(() async {
      await isar.assetEntitys.clear();
      await isar.sessionEntitys.clear();
      await isar.settingsEntitys.clear();
    });
  }

  /// Pump a widget with BLoC providers for integration testing
  static Future<void> pumpWidgetWithProviders(
    WidgetTester tester,
    Widget child,
  ) async {
    await tester.pumpWidget(MaterialApp(home: child));
  }
}

/// Extension for common test assertions
extension IntegrationTestAssertions on WidgetTester {
  /// Wait for a specific state to appear
  Future<void> waitForState(
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await pumpAndSettle(timeout);
    expect(finder, findsOneWidget);
  }

  /// Pump frames until a condition is met
  Future<void> pumpUntil(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final end = DateTime.now().add(timeout);
    while (!condition()) {
      if (DateTime.now().isAfter(end)) {
        throw TimeoutException('Condition not met within timeout');
      }
      await pump(const Duration(milliseconds: 100));
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}
