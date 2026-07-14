import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/app/app_bootstrap.dart';
import 'package:momentum/core/app/momentum_app.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/settings/domain/entities/app_preferences.dart';

import '../helpers/test_harness.dart';

void main() {
  testWidgets('creates and completes a task through the primary UI flow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AppBootstrap(child: MomentumApp()),
      ),
    );
    await waitForMomentumReady(container);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final createButton = find.byWidgetPredicate(
      (widget) =>
          widget is FloatingActionButton &&
          widget.key == const ValueKey(AppWidgetKeys.taskCreateButton),
      description: 'primary create-task floating action button',
    );
    expect(createButton, findsOneWidget);

    await tester.tap(createButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final titleField = find.byKey(const ValueKey(AppWidgetKeys.taskTitleField));
    expect(titleField, findsOneWidget);
    await tester.enterText(titleField, 'UI-Flow absichern');

    final saveButton = find.byKey(const ValueKey(AppWidgetKeys.taskSaveButton));
    await tester.ensureVisible(saveButton);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(saveButton);
    await tester.pump();
    final createdState = await waitForMomentumState(
      container,
      (state) => state.tasks.length == 1 && !state.isMutating,
    );
    await tester.pumpAndSettle();

    final tasksDestination = find.byKey(const ValueKey(AppWidgetKeys.navigationTasks));
    expect(tasksDestination, findsOneWidget);
    await tester.tap(tasksDestination);
    await tester.pumpAndSettle();

    final taskId = switch (createdState.tasks) {
      [final task] => task.id.value,
      _ => fail('Expected exactly one task after submitting the form.'),
    };
    final taskCard = find.byKey(ValueKey(AppWidgetKeys.taskCard(taskId)));
    expect(taskCard, findsOneWidget);
    expect(find.text('UI-Flow absichern'), findsOneWidget);

    final completionToggle = find.byKey(ValueKey(AppWidgetKeys.taskCompletionToggle(taskId)));
    await tester.tap(completionToggle);
    await tester.pump();
    await waitForMomentumState(
      container,
      (state) => switch (state.tasks) {
        [final task] => task.isCompleted && !state.isMutating,
        _ => false,
      },
    );
    await tester.pump(const Duration(milliseconds: 200));

    final completedState = container.read(momentumProvider);
    expect(completedState.tasks, hasLength(1));
    expect(switch (completedState.tasks) {
      [final task] => task.isCompleted,
      _ => false,
    }, isTrue);
    final completionButton = tester.widget<IconButton>(completionToggle);
    expect(switch (completionButton.icon) {
      Icon(:final icon) => icon,
      _ => null,
    }, equals(Icons.check_circle_rounded));
  });
}
