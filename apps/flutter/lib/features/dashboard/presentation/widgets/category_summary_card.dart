import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:momentum/core/theme/app_icon_sizes.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/atoms/app_surface.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/providers/momentum_providers.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';
import 'package:momentum/features/tasks/presentation/task_labels.dart';

class CategorySummaryCard extends ConsumerWidget {
  const CategorySummaryCard({required this.category, super.key});

  final TaskCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final metrics = ref.watch(categoryMetricsProvider(category));
    final semanticColors = context.semanticColors;
    final label = category.label(l10n);
    final summary = l10n.categorySummary(metrics.open, metrics.total);

    return AppSurface(
      semanticLabel: l10n.categoryCardSemantics(label, summary),
      backgroundColor: category.background(semanticColors),
      borderSide: BorderSide(color: category.background(semanticColors)),
      onTap: () {
        ref.read(momentumProvider.notifier).setCategoryFilter(category);
        const TasksRoute().go(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(
              category.icon,
              size: AppIconSizes.large,
              color: category.foreground(semanticColors),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.copyWith(
              color: category.foreground(semanticColors),
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            summary,
            style: context.textTheme.bodySmall?.copyWith(
              color: category.foreground(semanticColors),
            ),
          ),
        ],
      ),
    );
  }
}
