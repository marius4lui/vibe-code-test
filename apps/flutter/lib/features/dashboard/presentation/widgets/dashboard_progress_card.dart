import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_motion.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/atoms/app_surface.dart';
import 'package:momentum/features/momentum/presentation/providers/momentum_providers.dart';

class DashboardProgressCard extends ConsumerWidget {
  const DashboardProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final metrics = ref.watch(dashboardMetricsProvider);
    final percent = (metrics.progress * 100).round();

    return AppSurface(
      backgroundColor: context.colors.primaryContainer,
      foregroundColor: context.colors.onPrimaryContainer,
      borderSide: BorderSide(color: context.colors.primaryContainer),
      child: Semantics(
        label: l10n.progressSemantics(metrics.completed, metrics.total, percent),
        child: ExcludeSemantics(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.s24,
            runSpacing: AppSpacing.s16,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppLayout.maxReadingWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.progressTitle, style: context.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      l10n.completedCount(metrics.completed),
                      style: context.textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              SizedBox.square(
                dimension: AppSpacing.s64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: metrics.progress),
                      duration: AppMotion.instant,
                      curve: AppMotion.enter,
                      builder: (context, value, child) => CircularProgressIndicator(
                        value: value,
                        strokeWidth: AppSpacing.s8,
                        backgroundColor: context.colors.surface.withValues(alpha: 0.45),
                        color: context.colors.primary,
                      ),
                    ),
                    Text(l10n.percentValue(percent), style: context.textTheme.labelLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
