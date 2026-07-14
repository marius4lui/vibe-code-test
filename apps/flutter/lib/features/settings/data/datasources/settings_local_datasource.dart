import 'package:momentum/core/data/local/local_database.dart';
import 'package:momentum/features/settings/data/models/settings_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_local_datasource.g.dart';

abstract interface class ISettingsLocalDatasource {
  Future<SettingsModel?> load();

  Future<void> save(SettingsModel model);
}

final class SettingsLocalDatasourceImpl implements ISettingsLocalDatasource {
  SettingsLocalDatasourceImpl(this._database);

  static const String _boxName = 'momentum_settings_v1';
  static const String _preferencesKey = 'app_preferences';

  final ILocalDatabase _database;

  @override
  Future<SettingsModel?> load() async {
    final record = await _database.read(boxName: _boxName, key: _preferencesKey);
    return record == null ? null : SettingsModel.fromJson(record);
  }

  @override
  Future<void> save(SettingsModel model) {
    return _database.write(boxName: _boxName, key: _preferencesKey, value: model.toJson());
  }
}

@Riverpod(keepAlive: true)
Future<ISettingsLocalDatasource> settingsLocalDatasource(Ref ref) async {
  final database = await ref.read(localDatabaseProvider.future);
  return SettingsLocalDatasourceImpl(database);
}
