// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'momentum_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskById)
final taskByIdProvider = TaskByIdFamily._();

final class TaskByIdProvider
    extends $FunctionalProvider<MomentumTask?, MomentumTask?, MomentumTask?>
    with $Provider<MomentumTask?> {
  TaskByIdProvider._({required TaskByIdFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'taskByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskByIdHash();

  @override
  String toString() {
    return r'taskByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MomentumTask?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MomentumTask? create(Ref ref) {
    final argument = this.argument as String;
    return taskById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MomentumTask? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MomentumTask?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TaskByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskByIdHash() => r'9a0631bbf5e663c7218dce9823225697e7556ddf';

final class TaskByIdFamily extends $Family with $FunctionalFamilyOverride<MomentumTask?, String> {
  TaskByIdFamily._()
    : super(
        retry: null,
        name: r'taskByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskByIdProvider call(String taskId) => TaskByIdProvider._(argument: taskId, from: this);

  @override
  String toString() => r'taskByIdProvider';
}

@ProviderFor(filteredTasks)
final filteredTasksProvider = FilteredTasksProvider._();

final class FilteredTasksProvider
    extends $FunctionalProvider<List<MomentumTask>, List<MomentumTask>, List<MomentumTask>>
    with $Provider<List<MomentumTask>> {
  FilteredTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredTasksHash();

  @$internal
  @override
  $ProviderElement<List<MomentumTask>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<MomentumTask> create(Ref ref) {
    return filteredTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MomentumTask> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MomentumTask>>(value),
    );
  }
}

String _$filteredTasksHash() => r'fca806cc9c32a6c3a9f12b1be62db1afb3af6ce7';

@ProviderFor(todayTasks)
final todayTasksProvider = TodayTasksProvider._();

final class TodayTasksProvider
    extends $FunctionalProvider<List<MomentumTask>, List<MomentumTask>, List<MomentumTask>>
    with $Provider<List<MomentumTask>> {
  TodayTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayTasksHash();

  @$internal
  @override
  $ProviderElement<List<MomentumTask>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<MomentumTask> create(Ref ref) {
    return todayTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MomentumTask> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MomentumTask>>(value),
    );
  }
}

String _$todayTasksHash() => r'590e2e29c1402ed995a17eaeaf699d5767dfe3df';

@ProviderFor(dashboardMetrics)
final dashboardMetricsProvider = DashboardMetricsProvider._();

final class DashboardMetricsProvider
    extends $FunctionalProvider<DashboardMetrics, DashboardMetrics, DashboardMetrics>
    with $Provider<DashboardMetrics> {
  DashboardMetricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardMetricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardMetricsHash();

  @$internal
  @override
  $ProviderElement<DashboardMetrics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DashboardMetrics create(Ref ref) {
    return dashboardMetrics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardMetrics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardMetrics>(value),
    );
  }
}

String _$dashboardMetricsHash() => r'bb75e976b0fc8a142527126991c2b4742c719f93';

@ProviderFor(categoryMetrics)
final categoryMetricsProvider = CategoryMetricsFamily._();

final class CategoryMetricsProvider
    extends $FunctionalProvider<CategoryMetrics, CategoryMetrics, CategoryMetrics>
    with $Provider<CategoryMetrics> {
  CategoryMetricsProvider._({
    required CategoryMetricsFamily super.from,
    required TaskCategory super.argument,
  }) : super(
         retry: null,
         name: r'categoryMetricsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryMetricsHash();

  @override
  String toString() {
    return r'categoryMetricsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<CategoryMetrics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CategoryMetrics create(Ref ref) {
    final argument = this.argument as TaskCategory;
    return categoryMetrics(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryMetrics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryMetrics>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryMetricsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryMetricsHash() => r'54c121ab5cfb29231424fb182e233363c859e88d';

final class CategoryMetricsFamily extends $Family
    with $FunctionalFamilyOverride<CategoryMetrics, TaskCategory> {
  CategoryMetricsFamily._()
    : super(
        retry: null,
        name: r'categoryMetricsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoryMetricsProvider call(TaskCategory category) =>
      CategoryMetricsProvider._(argument: category, from: this);

  @override
  String toString() => r'categoryMetricsProvider';
}
