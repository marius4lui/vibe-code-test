// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_clock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appClock)
final appClockProvider = AppClockProvider._();

final class AppClockProvider extends $FunctionalProvider<IAppClock, IAppClock, IAppClock>
    with $Provider<IAppClock> {
  AppClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appClockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appClockHash();

  @$internal
  @override
  $ProviderElement<IAppClock> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  IAppClock create(Ref ref) {
    return appClock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IAppClock value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<IAppClock>(value));
  }
}

String _$appClockHash() => r'b8e4f01164a1746a9c26448b7f3b437f4fda1f30';
