import 'package:app/src/domain/repositories/asset_repository.dart';
import 'package:app/src/domain/usecases/media/delete_assets_usecase.dart';
import 'package:app/src/domain/usecases/media/refresh_photos_usecase.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_event.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final RefreshPhotosUseCase refreshPhotosUseCase;
  final DeleteAssetsUseCase deleteAssetsUseCase;
  final AssetRepository assetRepository;

  MediaBloc({
    required this.refreshPhotosUseCase,
    required this.deleteAssetsUseCase,
    required this.assetRepository,
  }) : super(const MediaInitial()) {
    on<LoadMediaEvent>(_onLoadMedia);
    on<RefreshMediaEvent>(_onRefreshMedia);
    on<DeleteMediaEvent>(_onDeleteMedia);
  }

  Future<void> _onLoadMedia(
    LoadMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    try {
      emit(const MediaLoading());
      final assets = await assetRepository.getAssets();
      emit(MediaLoaded(assets));
    } catch (e) {
      emit(MediaError(e.toString()));
    }
  }

  Future<void> _onRefreshMedia(
    RefreshMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    try {
      final currentAssets = await assetRepository.getAssets();
      emit(MediaRefreshing(currentAssets));

      await refreshPhotosUseCase.execute(year: event.year, month: event.month);

      final updatedAssets = await assetRepository.getAssets();
      emit(MediaLoaded(updatedAssets));
    } catch (e) {
      emit(MediaError(e.toString()));
    }
  }

  Future<void> _onDeleteMedia(
    DeleteMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    try {
      final currentAssets = await assetRepository.getAssets();
      emit(MediaDeleting(currentAssets));

      await deleteAssetsUseCase.execute(
        assets: event.assets,
        isDryRun: event.isDryRun,
      );

      final updatedAssets = await assetRepository.getAssets();
      emit(MediaLoaded(updatedAssets));
    } catch (e) {
      emit(MediaError(e.toString()));
    }
  }
}
