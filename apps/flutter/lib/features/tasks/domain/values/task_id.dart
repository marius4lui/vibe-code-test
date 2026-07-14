import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_id.freezed.dart';

@Freezed(copyWith: false, map: FreezedMapOptions.none, when: FreezedWhenOptions.none)
sealed class TaskId with _$TaskId {
  const TaskId._();

  const factory TaskId._raw(String value) = _TaskId;

  factory TaskId(String input) {
    final value = input.trim();
    if (value.isEmpty) {
      throw ArgumentError.value(input, 'input', 'TaskId cannot be blank.');
    }
    return TaskId._raw(value);
  }
}
