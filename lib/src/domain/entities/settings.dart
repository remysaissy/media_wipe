import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  final int id;
  final ThemeMode themeMode;
  final bool hasPhotosAccess;
  final bool hasInAppReview;
  final bool debugDryRemoval;

  const Settings({
    required this.id,
    required this.themeMode,
    required this.hasPhotosAccess,
    required this.hasInAppReview,
    required this.debugDryRemoval,
  });

  factory Settings.defaultSettings() {
    return const Settings(
      id: 0,
      themeMode: ThemeMode.system,
      hasPhotosAccess: false,
      hasInAppReview: false,
      debugDryRemoval: true,
    );
  }

  Settings copyWith({
    int? id,
    ThemeMode? themeMode,
    bool? hasPhotosAccess,
    bool? hasInAppReview,
    bool? debugDryRemoval,
  }) {
    return Settings(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      hasPhotosAccess: hasPhotosAccess ?? this.hasPhotosAccess,
      hasInAppReview: hasInAppReview ?? this.hasInAppReview,
      debugDryRemoval: debugDryRemoval ?? this.debugDryRemoval,
    );
  }

  @override
  List<Object?> get props => [
    id,
    themeMode,
    hasPhotosAccess,
    hasInAppReview,
    debugDryRemoval,
  ];
}
