import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/extensions.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/core/theme/app_icon_sizes.dart';
import 'package:momentum/core/theme/app_motion.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/time/app_clock.dart';
import 'package:momentum/core/widgets/app_badge.dart';
import 'package:momentum/core/widgets/atoms/app_surface.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/providers/momentum_providers.dart';
import 'package:momentum/features/tasks/domain/values/task_id.dart';
import 'package:momentum/features/tasks/presentation/task_labels.dart';
import 'package:momentum/features/tasks/presentation/widgets/delete_task_dialog.dart';

enum TaskCardAction { edit, delete }

class TaskCard extends ConsumerWidget {
  const TaskCard({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final task = ref.watch(taskByIdProvider(taskId));
    final isMutating = ref.watch(momentumProvider.select((state) => state.isMutating));
    if (task == null) return const SizedBox.shrink();

    final categoryColor = task.category.foreground(context.semanticColors);
    final categoryBackground = task.category.background(context.semanticColors);
    final priorityColor = task.priority.foreground(context.semanticColors);
    final priorityBackground = task.priority.background(context.semanticColors);
    final dateLabel = task.scheduledDate.formatShortDate(l10n);
    final scheduledTime = task.scheduledTime;
    final timeLabel = scheduledTime == null
        ? null
        : TimeOfDay(
            hour: scheduledTime.inHours,
            minute: scheduledTime.inMinutes.remainder(60),
          ).format(context);
    final scheduleLabel = timeLabel == null ? dateLabel : l10n.dateAtTime(dateLabel, timeLabel);
    final now = ref.read(appClockProvider).nowLocal();
    final isOverdue =
        !task.isCompleted && task.scheduledDate.localDayStart.isBefore(now.localDayStart);
    final semanticsLabel = task.isCompleted
        ? l10n.taskCompletedSemantics(task.title.value)
        : l10n.taskOpenSemantics(task.title.value);

    return AnimatedOpacity(
      duration: AppMotion.instant,
      opacity: task.isCompleted ? 0.68 : 1,
      child: AppSurface(
        key: ValueKey(AppWidgetKeys.taskCard(taskId)),
        semanticLabel: semanticsLabel,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              button: true,
              checked: task.isCompleted,
              label: task.isCompleted ? l10n.reopenTaskTooltip : l10n.completeTaskTooltip,
              child: IconButton(
                key: ValueKey(AppWidgetKeys.taskCompletionToggle(taskId)),
                tooltip: task.isCompleted ? l10n.reopenTaskTooltip : l10n.completeTaskTooltip,
                onPressed: isMutating
                    ? null
                    : () =>
                          unawaited(ref.read(momentumProvider.notifier).toggleTask(TaskId(taskId))),
                icon: Icon(
                  task.isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: task.isCompleted
                      ? context.semanticColors.success
                      : context.colors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title.value,
                    style: context.textTheme.titleMedium?.copyWith(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (task.description case final String description) ...[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s12),
                  Wrap(
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s8,
                    children: [
                      AppBadge(
                        label: task.category.label(l10n),
                        icon: task.category.icon,
                        foregroundColor: categoryColor,
                        backgroundColor: categoryBackground,
                      ),
                      AppBadge(
                        label: task.priority.label(l10n),
                        icon: task.priority.icon,
                        foregroundColor: priorityColor,
                        backgroundColor: priorityBackground,
                      ),
                      if (isOverdue)
                        AppBadge(
                          label: l10n.overdue,
                          icon: Icons.schedule_rounded,
                          foregroundColor: context.colors.error,
                          backgroundColor: context.colors.errorContainer,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: AppIconSizes.small,
                        color: context.colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      Expanded(
                        child: Text(
                          scheduleLabel,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<TaskCardAction>(
              key: ValueKey(AppWidgetKeys.taskEditButton(taskId)),
              tooltip: l10n.taskMenuTooltip,
              enabled: !isMutating,
              onSelected: (action) => unawaited(_handleAction(context, ref, action)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: TaskCardAction.edit,
                  child: ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: Text(l10n.editAction),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: TaskCardAction.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: context.colors.error),
                    title: Text(
                      l10n.deleteAction,
                      style: context.textTheme.bodyLarge?.copyWith(color: context.colors.error),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(BuildContext context, WidgetRef ref, TaskCardAction action) async {
    final task = ref.read(taskByIdProvider(taskId));
    if (task == null) return;
    if (action == TaskCardAction.edit) {
      unawaited(EditTaskRoute(taskId: taskId).push<void>(context));
      return;
    }

    final dialogContext = context;
    final confirmed = await showDialog<bool>(
      context: dialogContext,
      routeSettings: const RouteSettings(name: 'delete-task-dialog'),
      builder: (context) => DeleteTaskDialog(taskTitle: task.title.value),
    );
    if (!dialogContext.mounted || confirmed != true) return;
    unawaited(ref.read(momentumProvider.notifier).deleteTask(TaskId(taskId)));
  }
}
