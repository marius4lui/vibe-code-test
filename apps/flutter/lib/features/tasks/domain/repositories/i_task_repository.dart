import 'package:momentum/features/tasks/domain/entities/momentum_task.dart';
import 'package:momentum/features/tasks/domain/values/task_id.dart';

abstract interface class ITaskRepository {
  Future<List<MomentumTask>> loadAll();

  Future<void> upsert(MomentumTask task);

  Future<void> upsertAll(List<MomentumTask> tasks);

  Future<void> delete(TaskId id);
}
