import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/time/app_clock.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/state/momentum_state.dart';
import 'package:momentum/features/settings/domain/entities/app_preferences.dart';
import 'package:momentum/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:momentum/features/settings/repositories/settings_repository.dart';
import 'package:momentum/features/tasks/domain/entities/momentum_task.dart';
import 'package:momentum/features/tasks/domain/repositories/i_task_repository.dart';
import 'package:momentum/features/tasks/domain/values/task_id.dart';
import 'package:momentum/features/tasks/repositories/task_repository.dart';

final class FixedAppClock implements IAppClock {
  const FixedAppClock(this.value);

  final DateTime value;

  @override
  DateTime nowLocal() => value;
}

final class FakeTaskRepository implements ITaskRepository {
  FakeTaskRepository({List<MomentumTask> initialTasks = const <MomentumTask>[]})
    : _tasks = List<MomentumTask>.of(initialTasks);

  final List<MomentumTask> _tasks;

  int loadCount = 0;
  int upsertCount = 0;

  List<MomentumTask> get snapshot => List<MomentumTask>.unmodifiable(_tasks);

  @override
  Future<void> delete(TaskId id) async {
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<List<MomentumTask>> loadAll() async {
    loadCount++;
    return snapshot;
  }

  @override
  Future<void> upsert(MomentumTask task) async {
    upsertCount++;
    _replaceOrAdd(task);
  }

  @override
  Future<void> upsertAll(List<MomentumTask> tasks) async {
    for (final task in tasks) {
      _replaceOrAdd(task);
    }
  }

  void _replaceOrAdd(MomentumTask task) {
    final index = _tasks.indexWhere((candidate) => candidate.id == task.id);
    if (index < 0) {
      _tasks.add(task);
      return;
    }
    _tasks[index] = task;
  }
}

final class FakeSettingsRepository implements ISettingsRepository {
  FakeSettingsRepository({required AppPreferences initialPreferences})
    : _preferences = initialPreferences;

  AppPreferences _preferences;

  AppPreferences get snapshot => _preferences;

  @override
  Future<AppPreferences> load() async => _preferences;

  @override
  Future<void> save(AppPreferences preferences) async {
    _preferences = preferences;
  }
}

ProviderContainer createTestContainer({
  required FakeTaskRepository taskRepository,
  required FakeSettingsRepository settingsRepository,
  required IAppClock clock,
}) {
  return ProviderContainer.test(
    overrides: [
      taskRepositoryProvider.overrideWithValue(AsyncData<ITaskRepository>(taskRepository)),
      settingsRepositoryProvider.overrideWithValue(
        AsyncData<ISettingsRepository>(settingsRepository),
      ),
      appClockProvider.overrideWithValue(clock),
    ],
  );
}

Future<MomentumState> waitForMomentumState(
  ProviderContainer container,
  bool Function(MomentumState state) predicate,
) async {
  final completer = Completer<MomentumState>();
  final subscription = container.listen<MomentumState>(momentumProvider, (previous, next) {
    if (predicate(next) && !completer.isCompleted) completer.complete(next);
  }, fireImmediately: true);

  try {
    return await completer.future.timeout(const Duration(seconds: 3));
  } finally {
    subscription.close();
  }
}

Future<MomentumState> waitForMomentumReady(ProviderContainer container) {
  return waitForMomentumState(container, (state) => !state.isLoading);
}
