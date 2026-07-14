// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsLocalDatasource)
final settingsLocalDatasourceProvider = SettingsLocalDatasourceProvider._();

final class SettingsLocalDatasourceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ISettingsLocalDatasource>,
          ISettingsLocalDatasource,
          FutureOr<ISettingsLocalDatasource>
        >
    with $FutureModifier<ISettingsLocalDatasource>, $FutureProvider<ISettingsLocalDatasource> {
  SettingsLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsLocalDatasourceHash();

  @$internal
  @override
  $FutureProviderElement<ISettingsLocalDatasource> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ISettingsLocalDatasource> create(Ref ref) {
    return settingsLocalDatasource(ref);
  }
}

String _$settingsLocalDatasourceHash() => r'bbc99d3d94155121ea191ddb0cfc14156be49bb3';
