import 'package:equatable/equatable.dart';

class Asset extends Equatable {
  final int id;
  final String assetId;
  final DateTime creationDate;

  const Asset({
    required this.id,
    required this.assetId,
    required this.creationDate,
  });

  Asset copyWith({int? id, String? assetId, DateTime? creationDate}) {
    return Asset(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  List<Object?> get props => [id, assetId, creationDate];
}
