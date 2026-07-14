import 'package:flutter/material.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/features/dashboard/presentation/widgets/dashboard_progress_card.dart';
import 'package:momentum/features/dashboard/presentation/widgets/streak_card.dart';

class DashboardSummaryGrid extends StatelessWidget {
  const DashboardSummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppLayout.compactBreakpoint) {
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: DashboardProgressCard()),
              SizedBox(width: AppSpacing.s12),
              Expanded(child: StreakCard()),
            ],
          );
        }
        return const Column(
          children: [
            DashboardProgressCard(),
            SizedBox(height: AppSpacing.s12),
            StreakCard(),
          ],
        );
      },
    );
  }
}
