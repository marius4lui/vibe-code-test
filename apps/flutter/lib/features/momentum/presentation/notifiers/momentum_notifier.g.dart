// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'momentum_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MomentumNotifier)
final momentumProvider = MomentumNotifierProvider._();

final class MomentumNotifierProvider extends $NotifierProvider<MomentumNotifier, MomentumState> {
  MomentumNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'momentumProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$momentumNotifierHash();

  @$internal
  @override
  MomentumNotifier create() => MomentumNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MomentumState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MomentumState>(value),
    );
  }
}

String _$momentumNotifierHash() => r'e53a209d4ea92adbe72d351b40c980d89335853b';

abstract class _$MomentumNotifier extends $Notifier<MomentumState> {
  MomentumState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MomentumState, MomentumState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MomentumState, MomentumState>,
              MomentumState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
