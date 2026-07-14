import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';
import 'package:momentum/features/tasks/domain/values/task_id.dart';
import 'package:momentum/features/tasks/domain/values/task_title.dart';

part 'momentum_task.freezed.dart';

@freezed
sealed class MomentumTask with _$MomentumTask {
  const MomentumTask._();

  const factory MomentumTask({
    required TaskId id,
    required TaskTitle title,
    String? description,
    required TaskCategory category,
    required TaskPriority priority,
    required DateTime scheduledDate,
    Duration? scheduledTime,
    DateTime? completedAt,
  }) = _MomentumTask;

  bool get isCompleted => completedAt != null;
}
