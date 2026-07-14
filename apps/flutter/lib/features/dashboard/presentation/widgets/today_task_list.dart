import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/atoms/app_surface.dart';
import 'package:momentum/core/widgets/empty_state.dart';
import 'package:momentum/core/widgets/section_header.dart';
import 'package:momentum/features/momentum/presentation/providers/momentum_providers.dart';
import 'package:momentum/features/tasks/presentation/widgets/task_card.dart';

class TodayTaskList extends ConsumerWidget {
  const TodayTaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tasks = ref.watch(todayTasksProvider);
    final completed = ref.watch(dashboardMetricsProvider.select((metrics) => metrics.completed));

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s32,
              AppSpacing.s20,
              AppSpacing.s12,
            ),
            child: SectionHeader(
              title: l10n.todaysTasksTitle,
              actionLabel: tasks.isEmpty ? null : l10n.viewAll,
              onAction: tasks.isEmpty ? null : () => const TasksRoute().go(context),
            ),
          ),
        ),
        if (tasks.isEmpty)
          SliverToBoxAdapter(
            child: EmptyState(
              icon: Icons.wb_sunny_outlined,
              title: l10n.todayEmptyTitle,
              message: l10n.todayEmptyBody,
              actionLabel: l10n.addTask,
              actionKey: const ValueKey(AppWidgetKeys.taskCreateButton),
              onAction: () => const CreateTaskRoute().push<void>(context),
            ),
          ),
        if (tasks.isNotEmpty) ...[
          if (completed == tasks.length)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                child: AppSurface(
                  backgroundColor: context.semanticColors.successContainer,
                  borderSide: BorderSide(color: context.semanticColors.successContainer),
                  child: Row(
                    children: [
                      Icon(Icons.celebration_outlined, color: context.semanticColors.success),
                      const SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.allDoneTitle, style: context.textTheme.titleMedium),
                            const SizedBox(height: AppSpacing.s4),
                            Text(l10n.allDoneBody, style: context.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s12,
              AppSpacing.s20,
              AppSpacing.s32,
            ),
            sliver: SliverList.separated(
              itemCount: tasks.length,
              itemBuilder: (context, index) => TaskCard(taskId: tasks[index].id.value),
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s12),
            ),
          ),
        ],
      ],
    );
  }
}
