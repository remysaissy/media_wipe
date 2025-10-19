import 'package:app/src/domain/usecases/settings/load_settings_usecase.dart';
import 'package:app/src/domain/usecases/settings/update_settings_usecase.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final LoadSettingsUseCase loadSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;

  SettingsCubit({
    required this.loadSettingsUseCase,
    required this.updateSettingsUseCase,
  }) : super(const SettingsInitial());

  Future<void> loadSettings() async {
    try {
      emit(const SettingsLoading());
      final settings = await loadSettingsUseCase.execute();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updateTheme(ThemeMode themeMode) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      final updatedSettings = currentState.settings.copyWith(
        themeMode: themeMode,
      );
      await updateSettingsUseCase.execute(updatedSettings);
      emit(SettingsLoaded(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updateDebugFlag(bool isDryRun) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      final updatedSettings = currentState.settings.copyWith(
        debugDryRemoval: isDryRun,
      );
      await updateSettingsUseCase.execute(updatedSettings);
      emit(SettingsLoaded(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updatePhotosAccess(bool hasAccess) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      final updatedSettings = currentState.settings.copyWith(
        hasPhotosAccess: hasAccess,
      );
      await updateSettingsUseCase.execute(updatedSettings);
      emit(SettingsLoaded(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> completeOnboarding() async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      final updatedSettings = currentState.settings.copyWith(
        hasPhotosAccess: true,
      );
      await updateSettingsUseCase.execute(updatedSettings);
      emit(SettingsLoaded(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> markInAppReviewCompleted() async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      final updatedSettings = currentState.settings.copyWith(
        hasInAppReview: true,
      );
      await updateSettingsUseCase.execute(updatedSettings);
      emit(SettingsLoaded(updatedSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
