import 'package:momentum/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:momentum/features/settings/data/models/settings_model.dart';
import 'package:momentum/features/settings/domain/entities/app_preferences.dart';
import 'package:momentum/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_repository.g.dart';

final class SettingsRepository implements ISettingsRepository {
  SettingsRepository(this._localDatasource);

  final ISettingsLocalDatasource _localDatasource;

  @override
  Future<AppPreferences> load() async {
    final model = await _localDatasource.load();
    return model?.toEntity() ?? const AppPreferences();
  }

  @override
  Future<void> save(AppPreferences preferences) {
    return _localDatasource.save(SettingsModel.fromDomain(preferences));
  }
}

@Riverpod(keepAlive: true)
Future<ISettingsRepository> settingsRepository(Ref ref) async {
  final datasource = await ref.read(settingsLocalDatasourceProvider.future);
  return SettingsRepository(datasource);
}
