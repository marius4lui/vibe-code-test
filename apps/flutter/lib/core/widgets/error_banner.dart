import 'package:flutter/material.dart';

import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_icon_sizes.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/atoms/app_surface.dart';

/// An inline error announcement with optional retry and dismiss actions.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.actionKey,
    this.dismissLabel,
    this.onDismiss,
    this.dismissKey,
  }) : assert((actionLabel == null) == (onAction == null)),
       assert((dismissLabel == null) == (onDismiss == null));

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;
  final String? dismissLabel;
  final VoidCallback? onDismiss;
  final Key? dismissKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      container: true,
      liveRegion: true,
      child: AppSurface(
        backgroundColor: colors.errorContainer,
        foregroundColor: colors.onErrorContainer,
        borderSide: BorderSide(color: colors.error),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.error_outline_rounded,
                size: AppIconSizes.standard,
                color: colors.error,
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.s4),
                  Text(message, style: context.textTheme.bodyMedium),
                  if (actionLabel != null || dismissLabel != null) ...[
                    const SizedBox(height: AppSpacing.s12),
                    Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s4,
                      children: [
                        if ((label: dismissLabel, action: onDismiss) case (
                          label: final String visibleDismissLabel,
                          action: final VoidCallback dismiss,
                        ))
                          TextButton(
                            key: dismissKey,
                            onPressed: dismiss,
                            style: TextButton.styleFrom(foregroundColor: colors.onErrorContainer),
                            child: Text(visibleDismissLabel),
                          ),
                        if ((label: actionLabel, action: onAction) case (
                          label: final String visibleActionLabel,
                          action: final VoidCallback action,
                        ))
                          FilledButton.tonal(
                            key: actionKey,
                            onPressed: action,
                            child: Text(visibleActionLabel),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
