import 'package:app/src/core/database/datastore.dart';
import 'package:app/src/core/services/subscriptions_service.dart';
import 'package:app/src/data/datasources/asset_local_datasource.dart';
import 'package:app/src/data/datasources/session_local_datasource.dart';
import 'package:app/src/data/datasources/settings_local_datasource.dart';
import 'package:app/src/data/repositories/asset_repository_impl.dart';
import 'package:app/src/data/repositories/session_repository_impl.dart';
import 'package:app/src/data/repositories/settings_repository_impl.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';
import 'package:app/src/domain/repositories/session_repository.dart';
import 'package:app/src/domain/repositories/settings_repository.dart';
import 'package:app/src/domain/usecases/media/authorize_photos_usecase.dart';
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
import 'package:app/src/domain/usecases/settings/request_in_app_review_usecase.dart';
import 'package:app/src/domain/usecases/settings/update_settings_usecase.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Core - Database
  final datastore = await Datastore.getInstance();
  getIt.registerLazySingleton<Datastore>(() => datastore);

  // Core - Services
  getIt.registerLazySingleton<SubscriptionsService>(
    () => SubscriptionsService(),
  );

  // Data Sources
  getIt.registerLazySingleton<AssetLocalDataSource>(
    () => AssetLocalDataSource(getIt<Datastore>().isar),
  );
  getIt.registerLazySingleton<SessionLocalDataSource>(
    () => SessionLocalDataSource(getIt<Datastore>().isar),
  );
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(getIt<Datastore>().isar),
  );

  // Repositories
  getIt.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(getIt<AssetLocalDataSource>()),
  );
  getIt.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(
      getIt<SessionLocalDataSource>(),
      getIt<AssetLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<SettingsLocalDataSource>()),
  );

  // Use Cases - Media
  getIt.registerLazySingleton<RefreshPhotosUseCase>(
    () => RefreshPhotosUseCase(getIt<AssetRepository>()),
  );
  getIt.registerLazySingleton<DeleteAssetsUseCase>(
    () => DeleteAssetsUseCase(getIt<AssetRepository>()),
  );
  getIt.registerLazySingleton<AuthorizePhotosUseCase>(
    () => AuthorizePhotosUseCase(getIt<AssetLocalDataSource>()),
  );

  // Use Cases - Sessions
  getIt.registerLazySingleton<StartSessionUseCase>(
    () => StartSessionUseCase(
      getIt<SessionRepository>(),
      getIt<AssetRepository>(),
    ),
  );
  getIt.registerLazySingleton<FinishSessionUseCase>(
    () => FinishSessionUseCase(getIt<SessionRepository>()),
  );
  getIt.registerLazySingleton<KeepAssetInSessionUseCase>(
    () => KeepAssetInSessionUseCase(
      getIt<SessionRepository>(),
      getIt<AssetRepository>(),
    ),
  );
  getIt.registerLazySingleton<DropAssetInSessionUseCase>(
    () => DropAssetInSessionUseCase(
      getIt<SessionRepository>(),
      getIt<AssetRepository>(),
    ),
  );
  getIt.registerLazySingleton<UndoLastOperationUseCase>(
    () => UndoLastOperationUseCase(getIt<SessionRepository>()),
  );
  getIt.registerLazySingleton<CommitRefineInSessionUseCase>(
    () => CommitRefineInSessionUseCase(getIt<SessionRepository>()),
  );
  getIt.registerLazySingleton<DropAllSessionsUseCase>(
    () => DropAllSessionsUseCase(getIt<SessionRepository>()),
  );

  // Use Cases - Settings
  getIt.registerLazySingleton<LoadSettingsUseCase>(
    () => LoadSettingsUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerLazySingleton<UpdateSettingsUseCase>(
    () => UpdateSettingsUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerLazySingleton<RequestInAppReviewUseCase>(
    () => RequestInAppReviewUseCase(),
  );

  // BLoCs/Cubits (Factories - new instance per request)
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
