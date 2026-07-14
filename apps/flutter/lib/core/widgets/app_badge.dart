import 'package:flutter/material.dart';

import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_icon_sizes.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_radii.dart';
import 'package:momentum/core/theme/app_spacing.dart';

/// A compact, non-interactive label for statuses, priorities, and categories.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.icon,
    this.semanticLabel,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final IconData? icon;
  final String? semanticLabel;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveForeground = foregroundColor ?? colors.onSecondaryContainer;

    return Semantics(
      label: semanticLabel ?? label,
      child: ExcludeSemantics(
        child: Container(
          constraints: const BoxConstraints(minHeight: AppLayout.badgeMinHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
          decoration: BoxDecoration(
            color: backgroundColor ?? colors.secondaryContainer,
            borderRadius: AppRadii.full,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon case final IconData visibleIcon) ...[
                Icon(visibleIcon, size: AppIconSizes.small, color: effectiveForeground),
                const SizedBox(width: AppSpacing.s4),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(color: effectiveForeground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
