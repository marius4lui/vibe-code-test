import 'package:flutter/material.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/section_header.dart';
import 'package:momentum/features/dashboard/presentation/widgets/category_summary_card.dart';
import 'package:momentum/features/tasks/domain/task_category.dart';

class CategoryOverview extends StatelessWidget {
  const CategoryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.categoriesTitle),
        const SizedBox(height: AppSpacing.s12),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= AppLayout.expandedBreakpoint ? 4 : 2;
            final totalGaps = AppSpacing.s12 * (columns - 1);
            final cardWidth = (constraints.maxWidth - totalGaps) / columns;
            return Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s12,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: const CategorySummaryCard(category: TaskCategory.work),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const CategorySummaryCard(category: TaskCategory.personal),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const CategorySummaryCard(category: TaskCategory.health),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const CategorySummaryCard(category: TaskCategory.learning),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
