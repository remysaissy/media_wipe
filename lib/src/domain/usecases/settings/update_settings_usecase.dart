import 'package:app/src/domain/entities/settings.dart';
import 'package:app/src/domain/repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository _repository;

  UpdateSettingsUseCase(this._repository);

  Future<void> execute(Settings settings) async {
    await _repository.updateSettings(settings);
  }
}
