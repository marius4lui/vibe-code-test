import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/extensions.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/state/app_operation.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';
import 'package:momentum/features/tasks/domain/validation/task_validation.dart';
import 'package:momentum/features/tasks/domain/values/task_id.dart';
import 'package:momentum/features/tasks/domain/values/task_title.dart';
import 'package:momentum/features/tasks/presentation/task_labels.dart';
import 'package:momentum/features/tasks/presentation/widgets/task_error_banner.dart';

class TaskEditorForm extends ConsumerStatefulWidget {
  const TaskEditorForm({
    required this.initialTitle,
    required this.initialDescription,
    required this.initialCategory,
    required this.initialPriority,
    required this.initialDate,
    this.taskId,
    this.initialTime,
    super.key,
  });

  final String? taskId;
  final String initialTitle;
  final String initialDescription;
  final TaskCategory initialCategory;
  final TaskPriority initialPriority;
  final DateTime initialDate;
  final Duration? initialTime;

  @override
  ConsumerState<TaskEditorForm> createState() => _TaskEditorFormState();
}

class _TaskEditorFormState extends ConsumerState<TaskEditorForm> {
  static const int _earliestYear = 2000;
  static const int _latestYear = 2100;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocusNode = FocusNode();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TaskCategory _category;
  late TaskPriority _priority;
  late DateTime _date;
  Duration? _time;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _category = widget.initialCategory;
    _priority = widget.initialPriority;
    _date = widget.initialDate;
    _time = widget.initialTime;
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final operation = ref.watch(momentumProvider.select((state) => state.activeOperation));
    final isSaving = operation == AppOperation.create || operation == AppOperation.update;

    ref.listen(momentumProvider.select((state) => state.successSerial), (previous, next) {
      if (previous == next || !context.isCurrentModalRoute) return;
      context.popOrGo(const TasksRoute());
    });

    final time = _time;
    final timeLabel = time == null
        ? l10n.timeLabel
        : TimeOfDay(hour: time.inHours, minute: time.inMinutes.remainder(60)).format(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.backTooltip,
          onPressed: () => context.popOrGo(const TasksRoute()),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(widget.taskId == null ? l10n.createTaskTitle : l10n.editTaskTitle),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: AppLayout.contentConstraints,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: AppSpacing.page,
                children: [
                  const TaskErrorBanner(),
                  const SizedBox(height: AppSpacing.s12),
                  TextFormField(
                    key: const ValueKey(AppWidgetKeys.taskTitleField),
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    enabled: !isSaving,
                    textInputAction: TextInputAction.next,
                    maxLength: TaskValidation.titleMaxLength,
                    decoration: InputDecoration(
                      labelText: l10n.taskTitleLabel,
                      hintText: l10n.taskTitleHint,
                      prefixIcon: const Icon(Icons.title_rounded),
                    ),
                    validator: (value) => switch (TaskValidation.validateTitle(value ?? '')) {
                      TaskTitleValidationError.required => l10n.validationTitleRequired,
                      TaskTitleValidationError.tooLong => l10n.validationTitleTooLong(
                        TaskValidation.titleMaxLength,
                      ),
                      null => null,
                    },
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextFormField(
                    key: const ValueKey(AppWidgetKeys.taskDescriptionField),
                    controller: _descriptionController,
                    enabled: !isSaving,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: TaskValidation.descriptionMaxLength,
                    decoration: InputDecoration(
                      labelText: l10n.taskDescriptionLabel,
                      hintText: l10n.taskDescriptionHint,
                      alignLabelWithHint: true,
                      prefixIcon: const Icon(Icons.notes_rounded),
                    ),
                    validator: (value) => switch (TaskValidation.validateDescription(value ?? '')) {
                      TaskDescriptionValidationError.tooLong => l10n.validationDescriptionTooLong(
                        TaskValidation.descriptionMaxLength,
                      ),
                      null => null,
                    },
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  DropdownButtonFormField<TaskCategory>(
                    initialValue: _category,
                    decoration: InputDecoration(
                      labelText: l10n.categoryLabel,
                      prefixIcon: Icon(_category.icon),
                    ),
                    items: [
                      for (final category in TaskCategory.values)
                        DropdownMenuItem(value: category, child: Text(category.label(l10n))),
                    ],
                    onChanged: isSaving
                        ? null
                        : (value) {
                            if (value == null) return;
                            setState(() => _category = value);
                          },
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  DropdownButtonFormField<TaskPriority>(
                    initialValue: _priority,
                    decoration: InputDecoration(
                      labelText: l10n.priorityLabel,
                      prefixIcon: Icon(_priority.icon),
                    ),
                    items: [
                      for (final priority in TaskPriority.values)
                        DropdownMenuItem(value: priority, child: Text(priority.label(l10n))),
                    ],
                    onChanged: isSaving
                        ? null
                        : (value) {
                            if (value == null) return;
                            setState(() => _priority = value);
                          },
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  OutlinedButton.icon(
                    key: const ValueKey(AppWidgetKeys.taskDateButton),
                    onPressed: isSaving ? null : _chooseDate,
                    icon: const Icon(Icons.event_outlined),
                    label: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(_date.formatLongDate(l10n)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  OutlinedButton.icon(
                    key: const ValueKey(AppWidgetKeys.taskTimeButton),
                    onPressed: isSaving ? null : _chooseTime,
                    icon: const Icon(Icons.schedule_outlined),
                    label: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(timeLabel),
                    ),
                  ),
                  if (_time != null)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: isSaving ? null : () => setState(() => _time = null),
                        icon: const Icon(Icons.schedule_send_outlined),
                        label: Text(l10n.removeTime),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.s24),
                  FilledButton.icon(
                    key: const ValueKey(AppWidgetKeys.taskSaveButton),
                    onPressed: isSaving ? null : _submit,
                    icon: isSaving
                        ? const SizedBox.square(
                            dimension: AppSpacing.s16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(isSaving ? l10n.savingTask : l10n.saveTask),
                  ),
                  SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _chooseDate() async {
    final dialogContext = context;
    final selected = await showDatePicker(
      context: dialogContext,
      routeSettings: const RouteSettings(name: 'task-date-picker'),
      initialDate: _date,
      firstDate: DateTime(_earliestYear),
      lastDate: DateTime(_latestYear),
    );
    if (!dialogContext.mounted || selected == null) return;
    setState(() => _date = selected);
  }

  Future<void> _chooseTime() async {
    final current = _time;
    final dialogContext = context;
    final selected = await showTimePicker(
      context: dialogContext,
      routeSettings: const RouteSettings(name: 'task-time-picker'),
      initialTime: current == null
          ? TimeOfDay.now()
          : TimeOfDay(hour: current.inHours, minute: current.inMinutes.remainder(60)),
    );
    if (!dialogContext.mounted || selected == null) return;
    setState(() {
      _time = Duration(hours: selected.hour, minutes: selected.minute);
    });
  }

  void _submit() {
    final currentForm = _formKey.currentState;
    if (currentForm == null || !currentForm.validate()) {
      _titleFocusNode.requestFocus();
      return;
    }

    final title = TaskTitle(_titleController.text);
    final description = TaskValidation.normalizeOptionalDescription(_descriptionController.text);
    final id = widget.taskId;
    if (id == null) {
      unawaited(
        ref
            .read(momentumProvider.notifier)
            .createTask(
              title: title,
              description: description,
              category: _category,
              priority: _priority,
              scheduledDate: _date,
              scheduledTime: _time,
            ),
      );
      return;
    }
    unawaited(
      ref
          .read(momentumProvider.notifier)
          .updateTask(
            id: TaskId(id),
            title: title,
            description: description,
            category: _category,
            priority: _priority,
            scheduledDate: _date,
            scheduledTime: _time,
          ),
    );
  }
}
