import 'package:momentum/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:momentum/features/tasks/data/models/task_model.dart';
import 'package:momentum/features/tasks/domain/entities/momentum_task.dart';
import 'package:momentum/features/tasks/domain/repositories/i_task_repository.dart';
import 'package:momentum/features/tasks/domain/values/task_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_repository.g.dart';

final class TaskRepository implements ITaskRepository {
  TaskRepository(this._localDatasource);

  final ITaskLocalDatasource _localDatasource;

  @override
  Future<List<MomentumTask>> loadAll() async {
    final models = await _localDatasource.loadAll();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<void> upsert(MomentumTask task) {
    return _localDatasource.upsert(TaskModel.fromDomain(task));
  }

  @override
  Future<void> upsertAll(List<MomentumTask> tasks) {
    return _localDatasource.upsertAll(tasks.map(TaskModel.fromDomain).toList(growable: false));
  }

  @override
  Future<void> delete(TaskId id) {
    return _localDatasource.delete(id.value);
  }
}

@Riverpod(keepAlive: true)
Future<ITaskRepository> taskRepository(Ref ref) async {
  final datasource = await ref.read(taskLocalDatasourceProvider.future);
  return TaskRepository(datasource);
}
