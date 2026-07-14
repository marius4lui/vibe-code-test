import 'package:momentum/features/settings/domain/entities/app_preferences.dart';

abstract interface class ISettingsRepository {
  Future<AppPreferences> load();

  Future<void> save(AppPreferences preferences);
}
