import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:momentum/features/settings/domain/app_theme_preference.dart';

part 'app_preferences.freezed.dart';

@freezed
sealed class AppPreferences with _$AppPreferences {
  const factory AppPreferences({
    @Default(false) bool onboardingCompleted,
    @Default(false) bool hasSeeded,
    @Default(AppThemePreference.system) AppThemePreference themePreference,
  }) = _AppPreferences;
}
