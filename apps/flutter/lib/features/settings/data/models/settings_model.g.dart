// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) => _SettingsModel(
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
  hasSeeded: json['hasSeeded'] as bool? ?? false,
  themePreference: json['themePreference'] as String? ?? 'system',
);

Map<String, dynamic> _$SettingsModelToJson(_SettingsModel instance) => <String, dynamic>{
  'onboardingCompleted': instance.onboardingCompleted,
  'hasSeeded': instance.hasSeeded,
  'themePreference': instance.themePreference,
};
