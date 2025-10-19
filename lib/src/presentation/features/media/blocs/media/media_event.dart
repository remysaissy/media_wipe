import 'package:app/src/domain/entities/asset.dart';
import 'package:equatable/equatable.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object?> get props => [];
}

class LoadMediaEvent extends MediaEvent {
  const LoadMediaEvent();
}

class RefreshMediaEvent extends MediaEvent {
  final int? year;
  final int? month;

  const RefreshMediaEvent({this.year, this.month});

  @override
  List<Object?> get props => [year, month];
}

class DeleteMediaEvent extends MediaEvent {
  final List<Asset> assets;
  final bool isDryRun;

  const DeleteMediaEvent({required this.assets, required this.isDryRun});

  @override
  List<Object?> get props => [assets, isDryRun];
}
