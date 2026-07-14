import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/extensions.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/time/app_clock.dart';
import 'package:momentum/features/dashboard/presentation/widgets/category_overview.dart';
import 'package:momentum/features/dashboard/presentation/widgets/dashboard_summary_grid.dart';
import 'package:momentum/features/dashboard/presentation/widgets/today_task_list.dart';
import 'package:momentum/features/tasks/presentation/widgets/task_error_banner.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = ref.read(appClockProvider).nowLocal();

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: Text(l10n.todayTitle)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.s20, 0, AppSpacing.s20, AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dashboardEyebrow,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  today.formatLongDate(l10n),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                const TaskErrorBanner(),
                const SizedBox(height: AppSpacing.s12),
                const DashboardSummaryGrid(),
                const SizedBox(height: AppSpacing.s32),
                const CategoryOverview(),
              ],
            ),
          ),
        ),
        const TodayTaskList(),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s64)),
      ],
    );
  }
}
