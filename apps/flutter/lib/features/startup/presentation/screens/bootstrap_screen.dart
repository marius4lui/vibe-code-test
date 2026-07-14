import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/error_banner.dart';
import 'package:momentum/core/widgets/loading_view.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';

class BootstrapScreen extends ConsumerWidget {
  const BootstrapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(momentumProvider);

    ref.listen(
      momentumProvider.select(
        (value) => (
          completed: value.preferences.onboardingCompleted,
          error: value.error,
          loading: value.isLoading,
        ),
      ),
      (previous, next) {
        if (next.loading || next.error != null) return;
        if (next.completed) {
          const TodayRoute().go(context);
          return;
        }
        const OnboardingRoute().go(context);
      },
    );

    return Scaffold(
      body: state.isLoading
          ? LoadingView(
              title: l10n.loadingTitle,
              message: l10n.loadingBody,
              semanticLabel: l10n.loadingSemantics,
            )
          : SafeArea(
              child: Center(
                child: Padding(
                  padding: AppSpacing.page,
                  child: ErrorBanner(
                    title: l10n.startupErrorTitle,
                    message: l10n.startupErrorBody,
                    actionLabel: l10n.retry,
                    actionKey: const ValueKey(AppWidgetKeys.errorRetryButton),
                    onAction: () => unawaited(ref.read(momentumProvider.notifier).retry()),
                  ),
                ),
              ),
            ),
    );
  }
}
