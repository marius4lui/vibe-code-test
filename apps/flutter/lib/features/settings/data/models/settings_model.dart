import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:momentum/features/settings/domain/app_theme_preference.dart';
import 'package:momentum/features/settings/domain/entities/app_preferences.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
sealed class SettingsModel with _$SettingsModel {
  const SettingsModel._();

  const factory SettingsModel({
    @Default(false) bool onboardingCompleted,
    @Default(false) bool hasSeeded,
    @Default('system') String themePreference,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);

  factory SettingsModel.fromDomain(AppPreferences preferences) {
    return SettingsModel(
      onboardingCompleted: preferences.onboardingCompleted,
      hasSeeded: preferences.hasSeeded,
      themePreference: preferences.themePreference.name,
    );
  }

  AppPreferences toEntity() {
    return AppPreferences(
      onboardingCompleted: onboardingCompleted,
      hasSeeded: hasSeeded,
      themePreference: switch (themePreference) {
        'system' => AppThemePreference.system,
        'light' => AppThemePreference.light,
        'dark' => AppThemePreference.dark,
        _ => throw FormatException('Unknown theme preference: $themePreference'),
      },
    );
  }
}
