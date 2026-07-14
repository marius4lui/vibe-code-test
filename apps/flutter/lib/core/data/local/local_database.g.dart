// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localDatabase)
final localDatabaseProvider = LocalDatabaseProvider._();

final class LocalDatabaseProvider
    extends
        $FunctionalProvider<AsyncValue<ILocalDatabase>, ILocalDatabase, FutureOr<ILocalDatabase>>
    with $FutureModifier<ILocalDatabase>, $FutureProvider<ILocalDatabase> {
  LocalDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDatabaseHash();

  @$internal
  @override
  $FutureProviderElement<ILocalDatabase> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ILocalDatabase> create(Ref ref) {
    return localDatabase(ref);
  }
}

String _$localDatabaseHash() => r'9dd90fb4f20c5db411692e9a6b6e70ca7eee79a5';
