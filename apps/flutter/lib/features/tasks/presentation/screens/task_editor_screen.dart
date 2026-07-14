import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:momentum/core/time/app_clock.dart';
import 'package:momentum/core/widgets/empty_state.dart';
import 'package:momentum/core/widgets/loading_view.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/providers/momentum_providers.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';
import 'package:momentum/features/tasks/presentation/widgets/task_editor_form.dart';

class TaskEditorScreen extends ConsumerWidget {
  const TaskEditorScreen({this.taskId, super.key});

  final String? taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isLoading = ref.watch(momentumProvider.select((state) => state.isLoading));
    if (isLoading) {
      return Scaffold(
        body: LoadingView(
          title: l10n.loadingTitle,
          message: l10n.loadingBody,
          semanticLabel: l10n.loadingSemantics,
        ),
      );
    }

    final id = taskId;
    if (id == null) {
      final now = ref.read(appClockProvider).nowLocal();
      return TaskEditorForm(
        initialCategory: TaskCategory.personal,
        initialDate: DateTime(now.year, now.month, now.day),
        initialDescription: '',
        initialPriority: TaskPriority.medium,
        initialTitle: '',
      );
    }

    final task = ref.watch(taskByIdProvider(id));
    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editTaskTitle)),
        body: EmptyState(
          icon: Icons.search_off_rounded,
          title: l10n.taskMissingTitle,
          message: l10n.taskMissingBody,
          actionLabel: l10n.viewAll,
          onAction: () => const TasksRoute().go(context),
        ),
      );
    }

    return TaskEditorForm(
      taskId: id,
      initialCategory: task.category,
      initialDate: task.scheduledDate,
      initialDescription: task.description ?? '',
      initialPriority: task.priority,
      initialTime: task.scheduledTime,
      initialTitle: task.title.value,
    );
  }
}
