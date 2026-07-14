import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:momentum/core/errors/app_error.dart';
import 'package:momentum/features/momentum/presentation/state/app_operation.dart';
import 'package:momentum/features/momentum/presentation/state/task_status_filter.dart';
import 'package:momentum/features/settings/domain/entities/app_preferences.dart';
import 'package:momentum/features/tasks/domain/entities/momentum_task.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';

part 'momentum_state.freezed.dart';

@freezed
sealed class MomentumState with _$MomentumState {
  const MomentumState._();

  const factory MomentumState({
    required AppPreferences preferences,
    @Default(<MomentumTask>[]) List<MomentumTask> tasks,
    @Default(true) bool isLoading,
    AppOperation? activeOperation,
    AppOperation? failedOperation,
    AppError? error,
    @Default('') String searchQuery,
    @Default(TaskStatusFilter.all) TaskStatusFilter statusFilter,
    TaskCategory? categoryFilter,
    TaskPriority? priorityFilter,
    @Default(0) int successSerial,
  }) = _MomentumState;

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      statusFilter != TaskStatusFilter.all ||
      categoryFilter != null ||
      priorityFilter != null;

  bool get isMutating => activeOperation != null;
}
