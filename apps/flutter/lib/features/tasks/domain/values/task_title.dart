import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:momentum/features/tasks/domain/validation/task_validation.dart';

part 'task_title.freezed.dart';

@Freezed(copyWith: false, map: FreezedMapOptions.none, when: FreezedWhenOptions.none)
sealed class TaskTitle with _$TaskTitle {
  const TaskTitle._();

  const factory TaskTitle._raw(String value) = _TaskTitle;

  static const int maxLength = TaskValidation.titleMaxLength;

  factory TaskTitle(String input) {
    return switch (TaskValidation.validateTitle(input)) {
      TaskTitleValidationError.required => throw ArgumentError.value(
        input,
        'input',
        'TaskTitle cannot be blank.',
      ),
      TaskTitleValidationError.tooLong => throw ArgumentError.value(
        input,
        'input',
        'TaskTitle cannot exceed $maxLength characters.',
      ),
      null => TaskTitle._raw(input.trim()),
    };
  }
}
