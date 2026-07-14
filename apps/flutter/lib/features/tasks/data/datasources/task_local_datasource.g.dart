// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskLocalDatasource)
final taskLocalDatasourceProvider = TaskLocalDatasourceProvider._();

final class TaskLocalDatasourceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ITaskLocalDatasource>,
          ITaskLocalDatasource,
          FutureOr<ITaskLocalDatasource>
        >
    with $FutureModifier<ITaskLocalDatasource>, $FutureProvider<ITaskLocalDatasource> {
  TaskLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskLocalDatasourceHash();

  @$internal
  @override
  $FutureProviderElement<ITaskLocalDatasource> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ITaskLocalDatasource> create(Ref ref) {
    return taskLocalDatasource(ref);
  }
}

String _$taskLocalDatasourceHash() => r'40b846539e51d7b16c9b7f8c9809dbe32f177715';
