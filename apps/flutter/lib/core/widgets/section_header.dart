import 'package:flutter/material.dart';

import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_spacing.dart';

/// A semantic section heading with optional supporting copy and text action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.actionKey,
  }) : assert((actionLabel == null) == (onAction == null));

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s8,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(header: true, child: Text(title, style: context.textTheme.titleLarge)),
            if (subtitle case final String visibleSubtitle) ...[
              const SizedBox(height: AppSpacing.s4),
              Text(
                visibleSubtitle,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        if ((label: actionLabel, action: onAction) case (
          label: final String visibleActionLabel,
          action: final VoidCallback action,
        ))
          TextButton(key: actionKey, onPressed: action, child: Text(visibleActionLabel)),
      ],
    );
  }
}
