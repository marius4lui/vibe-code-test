import 'package:flutter/material.dart';
import 'package:momentum/core/theme/app_semantic_colors.dart';
import 'package:momentum/features/momentum/presentation/state/task_status_filter.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/domain/task_priority.dart';
import 'package:momentum/l10n/app_localizations.dart';

extension TaskCategoryPresentation on TaskCategory {
  String label(AppLocalizations l10n) => switch (this) {
    TaskCategory.work => l10n.categoryWork,
    TaskCategory.personal => l10n.categoryPersonal,
    TaskCategory.health => l10n.categoryHealth,
    TaskCategory.learning => l10n.categoryLearning,
  };

  IconData get icon => switch (this) {
    TaskCategory.work => Icons.work_outline_rounded,
    TaskCategory.personal => Icons.home_outlined,
    TaskCategory.health => Icons.favorite_outline_rounded,
    TaskCategory.learning => Icons.auto_stories_outlined,
  };

  Color foreground(AppSemanticColors colors) => switch (this) {
    TaskCategory.work => colors.categoryWork,
    TaskCategory.personal => colors.categoryPersonal,
    TaskCategory.health => colors.categoryHealth,
    TaskCategory.learning => colors.categoryLearning,
  };

  Color background(AppSemanticColors colors) => switch (this) {
    TaskCategory.work => colors.categoryWorkContainer,
    TaskCategory.personal => colors.categoryPersonalContainer,
    TaskCategory.health => colors.categoryHealthContainer,
    TaskCategory.learning => colors.categoryLearningContainer,
  };
}

extension TaskPriorityPresentation on TaskPriority {
  String label(AppLocalizations l10n) => switch (this) {
    TaskPriority.low => l10n.priorityLow,
    TaskPriority.medium => l10n.priorityMedium,
    TaskPriority.high => l10n.priorityHigh,
  };

  IconData get icon => switch (this) {
    TaskPriority.low => Icons.arrow_downward_rounded,
    TaskPriority.medium => Icons.remove_rounded,
    TaskPriority.high => Icons.arrow_upward_rounded,
  };

  Color foreground(AppSemanticColors colors) => switch (this) {
    TaskPriority.low => colors.priorityLow,
    TaskPriority.medium => colors.priorityMedium,
    TaskPriority.high => colors.priorityHigh,
  };

  Color background(AppSemanticColors colors) => switch (this) {
    TaskPriority.low => colors.priorityLowContainer,
    TaskPriority.medium => colors.priorityMediumContainer,
    TaskPriority.high => colors.priorityHighContainer,
  };
}

extension TaskStatusFilterPresentation on TaskStatusFilter {
  String label(AppLocalizations l10n) => switch (this) {
    TaskStatusFilter.all => l10n.filterAll,
    TaskStatusFilter.open => l10n.filterOpen,
    TaskStatusFilter.completed => l10n.filterCompleted,
  };
}
