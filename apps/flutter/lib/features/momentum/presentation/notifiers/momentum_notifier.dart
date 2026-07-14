import 'dart:async';

import 'package:momentum/core/errors/app_error.dart';
import 'package:momentum/core/services/crash.dart';
import 'package:momentum/core/time/app_clock.dart';
import 'package:momentum/features/momentum/presentation/state/app_operation.dart';
import 'package:momentum/features/momentum/presentation/state/momentum_state.dart';
import 'package:momentum/features/momentum/presentation/state/task_status_filter.dart';
import 'package:momentum/features/settings/domain/app_theme_preference.dart';
import 'package:momentum/features/settings/domain/entities/app_preferences.dart';
import 'package:momentum/features/settings/repositories/settings_repository.dart';
import 'package:momentum/features/tasks/data/seed/task_seed_factory.dart';
import 'package:momentum/features/tasks/domain/entities/momentum_task.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';
import 'package:momentum/features/tasks/domain/values/task_id.dart';
import 'package:momentum/features/tasks/domain/values/task_title.dart';
import 'package:momentum/features/tasks/repositories/task_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'momentum_notifier.g.dart';

@Riverpod(keepAlive: true)
class MomentumNotifier extends _$MomentumNotifier {
  Timer? _searchDebounce;
  int _loadGeneration = 0;

  @override
  MomentumState build() {
    ref.onDispose(() => _searchDebounce?.cancel());
    unawaited(Future<void>.microtask(_load));
    return const MomentumState(preferences: AppPreferences());
  }

  Future<void> retry() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null, failedOperation: null);
    await _load();
    if (!ref.mounted) return;
  }

  Future<void> completeOnboarding() async {
    if (!_startOperation(AppOperation.onboarding)) return;
    final nextPreferences = state.preferences.copyWith(onboardingCompleted: true);
    try {
      final repository = await ref.read(settingsRepositoryProvider.future);
      if (!ref.mounted) return;
      await repository.save(nextPreferences);
      if (!ref.mounted) return;
      state = state.copyWith(preferences: nextPreferences, error: null, failedOperation: null);
    } on Object catch (error, stackTrace) {
      if (!ref.mounted) return;
      _recordFailure(AppOperation.onboarding, error, stackTrace);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(activeOperation: null);
      }
    }
  }

  Future<void> setThemePreference(AppThemePreference preference) async {
    if (preference == state.preferences.themePreference) return;
    if (!_startOperation(AppOperation.settings)) return;
    final nextPreferences = state.preferences.copyWith(themePreference: preference);
    try {
      final repository = await ref.read(settingsRepositoryProvider.future);
      if (!ref.mounted) return;
      await repository.save(nextPreferences);
      if (!ref.mounted) return;
      state = state.copyWith(preferences: nextPreferences, error: null, failedOperation: null);
    } on Object catch (error, stackTrace) {
      if (!ref.mounted) return;
      _recordFailure(AppOperation.settings, error, stackTrace);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(activeOperation: null);
      }
    }
  }

  Future<void> createTask({
    required TaskTitle title,
    required String? description,
    required TaskCategory category,
    required TaskPriority priority,
    required DateTime scheduledDate,
    required Duration? scheduledTime,
  }) async {
    if (!_startOperation(AppOperation.create)) return;
    final now = ref.read(appClockProvider).nowLocal();
    final task = MomentumTask(
      id: TaskId('task-${now.toUtc().microsecondsSinceEpoch}-${state.successSerial + 1}'),
      title: title,
      description: description,
      category: category,
      priority: priority,
      scheduledDate: DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day),
      scheduledTime: scheduledTime,
    );
    await _persistTask(task, AppOperation.create);
    if (!ref.mounted) return;
  }

  Future<void> updateTask({
    required TaskId id,
    required TaskTitle title,
    required String? description,
    required TaskCategory category,
    required TaskPriority priority,
    required DateTime scheduledDate,
    required Duration? scheduledTime,
  }) async {
    final current = _findTask(id);
    if (current == null || !_startOperation(AppOperation.update)) return;
    final updated = current.copyWith(
      title: title,
      description: description,
      category: category,
      priority: priority,
      scheduledDate: DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day),
      scheduledTime: scheduledTime,
    );
    await _persistTask(updated, AppOperation.update);
    if (!ref.mounted) return;
  }

  Future<void> toggleTask(TaskId id) async {
    final current = _findTask(id);
    if (current == null || !_startOperation(AppOperation.toggle)) return;
    final updated = current.copyWith(
      completedAt: current.isCompleted ? null : ref.read(appClockProvider).nowLocal(),
    );
    await _persistTask(updated, AppOperation.toggle);
    if (!ref.mounted) return;
  }

  Future<void> deleteTask(TaskId id) async {
    if (_findTask(id) == null || !_startOperation(AppOperation.delete)) return;
    try {
      final repository = await ref.read(taskRepositoryProvider.future);
      if (!ref.mounted) return;
      await repository.delete(id);
      if (!ref.mounted) return;
      final tasks = await repository.loadAll();
      if (!ref.mounted) return;
      state = state.copyWith(
        tasks: tasks,
        error: null,
        failedOperation: null,
        successSerial: state.successSerial + 1,
      );
    } on Object catch (error, stackTrace) {
      if (!ref.mounted) return;
      _recordFailure(AppOperation.delete, error, stackTrace);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(activeOperation: null);
      }
    }
  }

  void updateSearchQuery(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 120), () {
      if (!ref.mounted) return;
      state = state.copyWith(searchQuery: query.trim());
    });
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    state = state.copyWith(searchQuery: '');
  }

  void setStatusFilter(TaskStatusFilter filter) {
    state = state.copyWith(statusFilter: filter);
  }

  void setCategoryFilter(TaskCategory? category) {
    state = state.copyWith(categoryFilter: category);
  }

  void setPriorityFilter(TaskPriority? priority) {
    state = state.copyWith(priorityFilter: priority);
  }

  void resetFilters() {
    _searchDebounce?.cancel();
    state = state.copyWith(
      searchQuery: '',
      statusFilter: TaskStatusFilter.all,
      categoryFilter: null,
      priorityFilter: null,
    );
  }

  void clearError() {
    state = state.copyWith(error: null, failedOperation: null);
  }

  Future<void> _load() async {
    final loadGeneration = ++_loadGeneration;
    final taskRepositoryFuture = ref.read(taskRepositoryProvider.future);
    final settingsRepositoryFuture = ref.read(settingsRepositoryProvider.future);
    final clock = ref.read(appClockProvider);
    try {
      final taskRepository = await taskRepositoryFuture;
      if (!ref.mounted || loadGeneration != _loadGeneration) return;
      final settingsRepository = await settingsRepositoryFuture;
      if (!ref.mounted || loadGeneration != _loadGeneration) return;
      AppPreferences preferences = await settingsRepository.load();
      if (!ref.mounted || loadGeneration != _loadGeneration) return;
      List<MomentumTask> tasks = await taskRepository.loadAll();
      if (!ref.mounted || loadGeneration != _loadGeneration) return;

      if (!preferences.hasSeeded) {
        final existingIds = <String>{for (final task in tasks) task.id.value};
        final missingSeeds = <MomentumTask>[];
        for (final seed in TaskSeedFactory.create(clock.nowLocal())) {
          if (!existingIds.contains(seed.id.value)) missingSeeds.add(seed);
        }
        if (missingSeeds.isNotEmpty) {
          await taskRepository.upsertAll(missingSeeds);
          if (!ref.mounted || loadGeneration != _loadGeneration) return;
        }
        preferences = preferences.copyWith(hasSeeded: true);
        await settingsRepository.save(preferences);
        if (!ref.mounted || loadGeneration != _loadGeneration) return;
        tasks = await taskRepository.loadAll();
        if (!ref.mounted || loadGeneration != _loadGeneration) return;
      }

      if (!ref.mounted) return;
      if (loadGeneration != _loadGeneration) return;
      state = state.copyWith(
        preferences: preferences,
        tasks: tasks,
        isLoading: false,
        error: null,
        activeOperation: null,
        failedOperation: null,
      );
    } on Object catch (error, stackTrace) {
      if (!ref.mounted || loadGeneration != _loadGeneration) return;
      Crash.error(error, stackTrace, reason: 'Momentum.load');
      state = state.copyWith(
        isLoading: false,
        activeOperation: null,
        failedOperation: AppOperation.load,
        error: AppError.storage(error),
      );
    }
  }

  Future<void> _persistTask(MomentumTask task, AppOperation operation) async {
    try {
      final repository = await ref.read(taskRepositoryProvider.future);
      if (!ref.mounted) return;
      await repository.upsert(task);
      if (!ref.mounted) return;
      final tasks = await repository.loadAll();
      if (!ref.mounted) return;
      state = state.copyWith(
        tasks: tasks,
        error: null,
        failedOperation: null,
        successSerial: state.successSerial + 1,
      );
    } on Object catch (error, stackTrace) {
      if (!ref.mounted) return;
      _recordFailure(operation, error, stackTrace);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(activeOperation: null);
      }
    }
  }

  bool _startOperation(AppOperation operation) {
    if (state.activeOperation != null) return false;
    state = state.copyWith(activeOperation: operation, error: null, failedOperation: null);
    return true;
  }

  MomentumTask? _findTask(TaskId id) {
    for (final task in state.tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  void _recordFailure(AppOperation operation, Object error, StackTrace stackTrace) {
    Crash.error(error, stackTrace, reason: 'Momentum.${operation.name}');
    state = state.copyWith(failedOperation: operation, error: AppError.storage(error));
  }
}
