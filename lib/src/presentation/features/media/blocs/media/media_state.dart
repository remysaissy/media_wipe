import 'package:app/src/domain/entities/asset.dart';
import 'package:equatable/equatable.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object?> get props => [];
}

class MediaInitial extends MediaState {
  const MediaInitial();
}

class MediaLoading extends MediaState {
  const MediaLoading();
}

class MediaLoaded extends MediaState {
  final List<Asset> assets;

  const MediaLoaded(this.assets);

  @override
  List<Object?> get props => [assets];
}

class MediaRefreshing extends MediaState {
  final List<Asset> currentAssets;

  const MediaRefreshing(this.currentAssets);

  @override
  List<Object?> get props => [currentAssets];
}

class MediaDeleting extends MediaState {
  final List<Asset> remainingAssets;

  const MediaDeleting(this.remainingAssets);

  @override
  List<Object?> get props => [remainingAssets];
}

class MediaError extends MediaState {
  final String message;

  const MediaError(this.message);

  @override
  List<Object?> get props => [message];
}
