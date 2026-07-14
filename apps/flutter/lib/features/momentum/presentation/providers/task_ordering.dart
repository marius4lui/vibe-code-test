import 'package:momentum/features/tasks/domain/entities/momentum_task.dart';

abstract final class TaskOrdering {
  static int compare(MomentumTask first, MomentumTask second) {
    final completionComparison = (first.isCompleted ? 1 : 0).compareTo(second.isCompleted ? 1 : 0);
    if (completionComparison != 0) return completionComparison;

    final dateComparison = first.scheduledDate.compareTo(second.scheduledDate);
    if (dateComparison != 0) return dateComparison;

    final firstTime = first.scheduledTime ?? const Duration(days: 1);
    final secondTime = second.scheduledTime ?? const Duration(days: 1);
    final timeComparison = firstTime.compareTo(secondTime);
    if (timeComparison != 0) return timeComparison;

    final priorityComparison = second.priority.index.compareTo(first.priority.index);
    if (priorityComparison != 0) return priorityComparison;
    return first.title.value.compareTo(second.title.value);
  }
}
