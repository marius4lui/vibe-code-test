import 'package:momentum/core/data/local/local_database.dart';
import 'package:momentum/features/tasks/data/models/task_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_local_datasource.g.dart';

abstract interface class ITaskLocalDatasource {
  Future<List<TaskModel>> loadAll();

  Future<void> upsert(TaskModel model);

  Future<void> upsertAll(List<TaskModel> models);

  Future<void> delete(String id);
}

final class TaskLocalDatasourceImpl implements ITaskLocalDatasource {
  TaskLocalDatasourceImpl(this._database);

  static const String _boxName = 'momentum_tasks_v1';

  final ILocalDatabase _database;

  @override
  Future<List<TaskModel>> loadAll() async {
    final records = await _database.readAll(boxName: _boxName);
    return records.map(TaskModel.fromJson).toList(growable: false);
  }

  @override
  Future<void> upsert(TaskModel model) {
    return _database.write(boxName: _boxName, key: model.id, value: model.toJson());
  }

  @override
  Future<void> upsertAll(List<TaskModel> models) {
    if (models.isEmpty) return Future<void>.value();

    final values = <String, JsonMap>{for (final model in models) model.id: model.toJson()};
    return _database.writeAll(boxName: _boxName, values: values);
  }

  @override
  Future<void> delete(String id) {
    return _database.delete(boxName: _boxName, key: id);
  }
}

@Riverpod(keepAlive: true)
Future<ITaskLocalDatasource> taskLocalDatasource(Ref ref) async {
  final database = await ref.read(localDatabaseProvider.future);
  return TaskLocalDatasourceImpl(database);
}
