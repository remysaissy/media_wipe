import 'package:app/src/domain/entities/settings.dart';
import 'package:app/src/domain/repositories/settings_repository.dart';

class LoadSettingsUseCase {
  final SettingsRepository _repository;

  LoadSettingsUseCase(this._repository);

  Future<Settings> execute() async {
    return await _repository.getSettings();
  }
}
