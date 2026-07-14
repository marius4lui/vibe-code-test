import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/empty_state.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/providers/momentum_providers.dart';
import 'package:momentum/features/tasks/presentation/widgets/task_card.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tasks = ref.watch(filteredTasksProvider);
    final summary = ref.watch(
      momentumProvider.select(
        (state) => (hasActiveFilters: state.hasActiveFilters, total: state.tasks.length),
      ),
    );

    if (tasks.isEmpty) {
      final hasNoTasks = summary.total == 0;
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(
          icon: hasNoTasks ? Icons.checklist_rounded : Icons.search_off_rounded,
          title: hasNoTasks ? l10n.noTasksTitle : l10n.noResultsTitle,
          message: hasNoTasks ? l10n.noTasksBody : l10n.noResultsBody,
          actionLabel: hasNoTasks ? l10n.addTask : l10n.resetFilters,
          actionKey: ValueKey(
            hasNoTasks ? AppWidgetKeys.taskCreateButton : AppWidgetKeys.taskResetFilters,
          ),
          onAction: hasNoTasks
              ? () => const CreateTaskRoute().push<void>(context)
              : () => ref.read(momentumProvider.notifier).resetFilters(),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s20,
        AppSpacing.s12,
        AppSpacing.s20,
        AppSpacing.s64,
      ),
      sliver: SliverList.separated(
        itemCount: tasks.length,
        itemBuilder: (context, index) => TaskCard(taskId: tasks[index].id.value),
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s12),
      ),
    );
  }
}
