import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/tasks/presentation/widgets/task_error_banner.dart';
import 'package:momentum/features/tasks/presentation/widgets/task_list.dart';
import 'package:momentum/features/tasks/presentation/widgets/tasks_filter_bar.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final taskCount = ref.watch(momentumProvider.select((state) => state.tasks.length));

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: Text(l10n.tasksTitle)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.s20, 0, AppSpacing.s20, AppSpacing.s12),
            child: Text(
              l10n.taskCount(taskCount),
              style: context.textTheme.bodyLarge?.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            child: TaskErrorBanner(),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s12,
              AppSpacing.s20,
              AppSpacing.s8,
            ),
            child: TasksFilterBar(),
          ),
        ),
        const TaskList(),
      ],
    );
  }
}
