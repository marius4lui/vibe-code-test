import 'package:flutter/material.dart';

import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_spacing.dart';

/// A full-area loading state with one consolidated screen-reader announcement.
class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
    required this.title,
    required this.semanticLabel,
    this.message,
    this.progress,
  }) : assert(progress == null || (progress >= 0 && progress <= 1));

  final String title;
  final String semanticLabel;
  final String? message;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.page,
          child: Semantics(
            container: true,
            liveRegion: true,
            label: semanticLabel,
            child: ExcludeSemantics(
              child: ConstrainedBox(
                constraints: AppLayout.readingConstraints,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: AppLayout.progressIndicatorSize,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: AppLayout.progressStrokeWidth,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    Text(title, textAlign: TextAlign.center, style: context.textTheme.titleLarge),
                    if (message case final String visibleMessage) ...[
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        visibleMessage,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
