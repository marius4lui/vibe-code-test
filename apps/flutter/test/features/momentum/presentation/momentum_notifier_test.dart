import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/settings/domain/entities/app_preferences.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';
import 'package:momentum/features/tasks/domain/values/task_title.dart';

import '../../../helpers/test_harness.dart';

void main() {
  test('creates a task and completes it using the persisted source of truth', () async {
    final now = DateTime(2026, 7, 14, 9, 30);
    final taskRepository = FakeTaskRepository();
    final settingsRepository = FakeSettingsRepository(
      initialPreferences: const AppPreferences(onboardingCompleted: true, hasSeeded: true),
    );
    final container = createTestContainer(
      taskRepository: taskRepository,
      settingsRepository: settingsRepository,
      clock: FixedAppClock(now),
    );

    await waitForMomentumReady(container);
    await container
        .read(momentumProvider.notifier)
        .createTask(
          title: TaskTitle('Release vorbereiten'),
          description: 'Checkliste finalisieren',
          category: TaskCategory.work,
          priority: TaskPriority.high,
          scheduledDate: now,
          scheduledTime: const Duration(hours: 10, minutes: 15),
        );

    final createdState = container.read(momentumProvider);
    expect(createdState.tasks, hasLength(1));
    final createdTask = switch (createdState.tasks) {
      [final task] => task,
      _ => fail('Expected exactly one created task.'),
    };
    expect(createdTask.title.value, equals('Release vorbereiten'));
    expect(createdTask.isCompleted, isFalse);
    expect(taskRepository.snapshot, equals([createdTask]));

    await container.read(momentumProvider.notifier).toggleTask(createdTask.id);

    final completedTask = switch (container.read(momentumProvider).tasks) {
      [final task] => task,
      _ => fail('Expected exactly one completed task.'),
    };
    expect(completedTask.isCompleted, isTrue);
    expect(completedTask.completedAt, equals(now));
    expect(taskRepository.snapshot, equals([completedTask]));
    expect(taskRepository.upsertCount, equals(2));
    expect(taskRepository.loadCount, equals(3));
  });
}
