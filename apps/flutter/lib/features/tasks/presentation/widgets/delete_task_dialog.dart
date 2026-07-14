import 'package:flutter/material.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';

class DeleteTaskDialog extends StatelessWidget {
  const DeleteTaskDialog({required this.taskTitle, super.key});

  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      icon: const Icon(Icons.delete_outline_rounded),
      title: Text(l10n.deleteTaskTitle),
      content: Text(l10n.deleteTaskBody(taskTitle)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
        FilledButton(
          key: const ValueKey(AppWidgetKeys.taskDeleteButton),
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: context.colors.error,
            foregroundColor: context.colors.onError,
          ),
          child: Text(l10n.deleteConfirm),
        ),
      ],
    );
  }
}
