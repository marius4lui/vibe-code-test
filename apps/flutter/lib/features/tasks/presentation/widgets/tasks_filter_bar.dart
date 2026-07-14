import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/state/task_status_filter.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';
import 'package:momentum/features/tasks/presentation/task_labels.dart';

class TasksFilterBar extends ConsumerStatefulWidget {
  const TasksFilterBar({super.key});

  @override
  ConsumerState<TasksFilterBar> createState() => _TasksFilterBarState();
}

class _TasksFilterBarState extends ConsumerState<TasksFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_restoreSearchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filters = ref.watch(
      momentumProvider.select(
        (state) => (
          category: state.categoryFilter,
          hasActive: state.hasActiveFilters,
          priority: state.priorityFilter,
          status: state.statusFilter,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBar(
          key: const ValueKey(AppWidgetKeys.taskSearchField),
          controller: _searchController,
          hintText: l10n.searchHint,
          leading: const Icon(Icons.search_rounded),
          onChanged: (query) {
            setState(() => _searchText = query);
            ref.read(momentumProvider.notifier).updateSearchQuery(query);
          },
          trailing: [
            if (_searchText.isNotEmpty)
              IconButton(
                tooltip: l10n.clearSearchTooltip,
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchText = '';
                  });
                  ref.read(momentumProvider.notifier).clearSearch();
                },
                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              PopupMenuButton<TaskStatusFilter>(
                key: const ValueKey(AppWidgetKeys.taskStatusFilter),
                tooltip: l10n.filterStatus,
                onSelected: ref.read(momentumProvider.notifier).setStatusFilter,
                itemBuilder: (context) => [
                  for (final status in TaskStatusFilter.values)
                    PopupMenuItem(value: status, child: Text(status.label(l10n))),
                ],
                child: Chip(
                  avatar: const Icon(Icons.tune_rounded),
                  label: Text(filters.status.label(l10n)),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              PopupMenuButton<String>(
                key: const ValueKey(AppWidgetKeys.taskCategoryFilter),
                tooltip: l10n.filterCategory,
                onSelected: (value) {
                  ref
                      .read(momentumProvider.notifier)
                      .setCategoryFilter(value == 'all' ? null : TaskCategory.values.byName(value));
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'all', child: Text(l10n.allCategories)),
                  for (final category in TaskCategory.values)
                    PopupMenuItem(value: category.name, child: Text(category.label(l10n))),
                ],
                child: Chip(
                  avatar: Icon(filters.category?.icon ?? Icons.category_outlined),
                  label: Text(filters.category?.label(l10n) ?? l10n.allCategories),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              PopupMenuButton<String>(
                key: const ValueKey(AppWidgetKeys.taskPriorityFilter),
                tooltip: l10n.filterPriority,
                onSelected: (value) {
                  ref
                      .read(momentumProvider.notifier)
                      .setPriorityFilter(value == 'all' ? null : TaskPriority.values.byName(value));
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'all', child: Text(l10n.allPriorities)),
                  for (final priority in TaskPriority.values)
                    PopupMenuItem(value: priority.name, child: Text(priority.label(l10n))),
                ],
                child: Chip(
                  avatar: Icon(filters.priority?.icon ?? Icons.flag_outlined),
                  label: Text(filters.priority?.label(l10n) ?? l10n.allPriorities),
                ),
              ),
              if (filters.hasActive) ...[
                const SizedBox(width: AppSpacing.s8),
                TextButton.icon(
                  key: const ValueKey(AppWidgetKeys.taskResetFilters),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchText = '';
                    });
                    ref.read(momentumProvider.notifier).resetFilters();
                  },
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: Text(l10n.resetFilters),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _restoreSearchQuery(Duration _) {
    if (!context.mounted) return;
    final query = ref.read(momentumProvider).searchQuery;
    if (query.isEmpty) return;
    setState(() {
      _searchController.text = query;
      _searchText = query;
    });
  }
}
