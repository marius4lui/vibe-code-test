import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/time/app_clock.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/providers/task_ordering.dart';
import 'package:momentum/features/momentum/presentation/state/task_status_filter.dart';
import 'package:momentum/features/tasks/domain/entities/momentum_task.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'momentum_providers.g.dart';

typedef DashboardMetrics = ({int completed, int streak, int total, double progress});
typedef CategoryMetrics = ({int open, int total});

@riverpod
MomentumTask? taskById(Ref ref, String taskId) {
  final tasks = ref.watch(momentumProvider.select((state) => state.tasks));
  for (final task in tasks) {
    if (task.id.value == taskId) return task;
  }
  return null;
}

@riverpod
List<MomentumTask> filteredTasks(Ref ref) {
  final projection = ref.watch(
    momentumProvider.select(
      (state) => (
        tasks: state.tasks,
        query: state.searchQuery,
        status: state.statusFilter,
        category: state.categoryFilter,
        priority: state.priorityFilter,
      ),
    ),
  );
  final normalizedQuery = projection.query.trim().toLowerCase();
  final results = <MomentumTask>[];

  for (final task in projection.tasks) {
    final description = task.description;
    final matchesDescription =
        description != null && description.toLowerCase().contains(normalizedQuery);
    final matchesQuery =
        normalizedQuery.isEmpty ||
        task.title.value.toLowerCase().contains(normalizedQuery) ||
        matchesDescription;
    final matchesStatus = switch (projection.status) {
      TaskStatusFilter.all => true,
      TaskStatusFilter.open => !task.isCompleted,
      TaskStatusFilter.completed => task.isCompleted,
    };
    final matchesCategory = projection.category == null || task.category == projection.category;
    final matchesPriority = projection.priority == null || task.priority == projection.priority;
    if (matchesQuery && matchesStatus && matchesCategory && matchesPriority) {
      results.add(task);
    }
  }

  results.sort(TaskOrdering.compare);
  return results;
}

@riverpod
List<MomentumTask> todayTasks(Ref ref) {
  final tasks = ref.watch(momentumProvider.select((state) => state.tasks));
  final today = ref.read(appClockProvider).nowLocal();
  final results = <MomentumTask>[];
  for (final task in tasks) {
    if (DateUtils.isSameDay(task.scheduledDate, today)) results.add(task);
  }
  results.sort(TaskOrdering.compare);
  return results;
}

@riverpod
DashboardMetrics dashboardMetrics(Ref ref) {
  final tasks = ref.watch(momentumProvider.select((state) => state.tasks));
  final now = ref.read(appClockProvider).nowLocal();
  var total = 0;
  var completed = 0;
  final completionDays = <DateTime>{};

  for (final task in tasks) {
    if (DateUtils.isSameDay(task.scheduledDate, now)) {
      total++;
      if (task.isCompleted) completed++;
    }
    final completedAt = task.completedAt?.toLocal();
    if (completedAt != null) {
      completionDays.add(DateTime(completedAt.year, completedAt.month, completedAt.day));
    }
  }

  final today = DateTime(now.year, now.month, now.day);
  var cursor = completionDays.contains(today) ? today : today.subtract(const Duration(days: 1));
  var streak = 0;
  while (completionDays.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  return (
    completed: completed,
    streak: streak,
    total: total,
    progress: total == 0 ? 0 : completed / total,
  );
}

@riverpod
CategoryMetrics categoryMetrics(Ref ref, TaskCategory category) {
  final tasks = ref.watch(momentumProvider.select((state) => state.tasks));
  final today = ref.read(appClockProvider).nowLocal();
  var total = 0;
  var open = 0;
  for (final task in tasks) {
    if (task.category != category || !DateUtils.isSameDay(task.scheduledDate, today)) continue;
    total++;
    if (!task.isCompleted) open++;
  }
  return (open: open, total: total);
}
