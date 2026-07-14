import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_icon_sizes.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/atoms/app_surface.dart';
import 'package:momentum/features/momentum/presentation/providers/momentum_providers.dart';

class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final streak = ref.watch(dashboardMetricsProvider.select((metrics) => metrics.streak));

    return AppSurface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.s12),
              decoration: BoxDecoration(
                color: context.semanticColors.priorityMediumContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                size: AppIconSizes.large,
                color: context.semanticColors.priorityMedium,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.streakTitle, style: context.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.s4),
                Text(l10n.streakDays(streak), style: context.textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  l10n.streakBody,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
