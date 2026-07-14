import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:momentum/features/tasks/domain/entities/momentum_task.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';
import 'package:momentum/features/tasks/domain/validation/task_validation.dart';
import 'package:momentum/features/tasks/domain/values/task_id.dart';
import 'package:momentum/features/tasks/domain/values/task_title.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
sealed class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String id,
    required String title,
    String? description,
    required String category,
    required String priority,
    required DateTime scheduledDate,
    int? scheduledTimeMicroseconds,
    DateTime? completedAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

  factory TaskModel.fromDomain(MomentumTask task) {
    final scheduledTime = task.scheduledTime;
    if (scheduledTime != null) {
      _validateScheduledTime(scheduledTime);
    }

    return TaskModel(
      id: task.id.value,
      title: task.title.value,
      description: _normalizeDescription(task.description),
      category: task.category.name,
      priority: task.priority.name,
      scheduledDate: task.scheduledDate,
      scheduledTimeMicroseconds: scheduledTime?.inMicroseconds,
      completedAt: task.completedAt,
    );
  }

  MomentumTask toEntity() {
    final timeMicroseconds = scheduledTimeMicroseconds;
    final scheduledTime = timeMicroseconds == null
        ? null
        : Duration(microseconds: timeMicroseconds);
    if (scheduledTime != null) {
      _validateScheduledTime(scheduledTime);
    }

    return MomentumTask(
      id: TaskId(id),
      title: TaskTitle(title),
      description: _normalizeDescription(description),
      category: _category,
      priority: _priority,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      completedAt: completedAt,
    );
  }

  TaskCategory get _category => switch (category) {
    'work' => TaskCategory.work,
    'personal' => TaskCategory.personal,
    'health' => TaskCategory.health,
    'learning' => TaskCategory.learning,
    _ => throw FormatException('Unknown task category: $category'),
  };

  TaskPriority get _priority => switch (priority) {
    'low' => TaskPriority.low,
    'medium' => TaskPriority.medium,
    'high' => TaskPriority.high,
    _ => throw FormatException('Unknown task priority: $priority'),
  };

  static String? _normalizeDescription(String? value) {
    if (value == null) return null;
    return TaskValidation.normalizeOptionalDescription(value);
  }

  static void _validateScheduledTime(Duration value) {
    if (!TaskValidation.isValidScheduledTime(value)) {
      throw ArgumentError.value(value, 'value', 'Scheduled time must be within a single day.');
    }
  }
}
