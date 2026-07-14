import 'package:momentum/features/tasks/domain/entities/momentum_task.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';
import 'package:momentum/features/tasks/domain/values/task_id.dart';
import 'package:momentum/features/tasks/domain/values/task_title.dart';

abstract final class TaskSeedFactory {
  static List<MomentumTask> create(DateTime nowLocal) {
    final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final twoDaysAgo = today.subtract(const Duration(days: 2));
    final tomorrow = today.add(const Duration(days: 1));

    return [
      MomentumTask(
        id: TaskId('seed-plan-priorities'),
        title: TaskTitle('Plan weekly priorities'),
        description: 'Choose the three outcomes that deserve your attention this week.',
        category: TaskCategory.work,
        priority: TaskPriority.high,
        scheduledDate: today,
        scheduledTime: const Duration(hours: 9),
      ),
      MomentumTask(
        id: TaskId('seed-walk'),
        title: TaskTitle('Take a 20-minute walk'),
        category: TaskCategory.health,
        priority: TaskPriority.medium,
        scheduledDate: today,
        scheduledTime: const Duration(hours: 18),
        completedAt: nowLocal.subtract(const Duration(hours: 1)),
      ),
      MomentumTask(
        id: TaskId('seed-read'),
        title: TaskTitle('Read one chapter'),
        description: 'Continue the book on the nightstand.',
        category: TaskCategory.learning,
        priority: TaskPriority.low,
        scheduledDate: today,
      ),
      MomentumTask(
        id: TaskId('seed-budget'),
        title: TaskTitle('Review the monthly budget'),
        category: TaskCategory.personal,
        priority: TaskPriority.medium,
        scheduledDate: tomorrow,
        scheduledTime: const Duration(hours: 19),
      ),
      MomentumTask(
        id: TaskId('seed-inbox'),
        title: TaskTitle('Clear the priority inbox'),
        category: TaskCategory.work,
        priority: TaskPriority.high,
        scheduledDate: yesterday,
        completedAt: yesterday.add(const Duration(hours: 16)),
      ),
      MomentumTask(
        id: TaskId('seed-stretch'),
        title: TaskTitle('Morning mobility routine'),
        category: TaskCategory.health,
        priority: TaskPriority.medium,
        scheduledDate: twoDaysAgo,
        completedAt: twoDaysAgo.add(const Duration(hours: 8)),
      ),
    ];
  }
}
