import 'package:flutter/material.dart';

import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_radii.dart';
import 'package:momentum/core/theme/app_spacing.dart';

/// The shared rounded surface and ink-response policy for cards and tiles.
class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.padding = AppSpacing.card,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = AppRadii.large,
    this.borderSide,
    this.elevation = AppLayout.flatElevation,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius borderRadius;
  final BorderSide? borderSide;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: borderSide ?? BorderSide(color: colors.outlineVariant),
    );
    final content = Padding(padding: padding, child: child);
    final interactiveContent = onTap == null
        ? content
        : ConstrainedBox(
            constraints: AppLayout.touchTargetConstraints,
            child: InkWell(customBorder: shape, onTap: onTap, child: content),
          );

    return Padding(
      padding: margin,
      child: Semantics(
        container: true,
        label: semanticLabel,
        button: onTap != null,
        child: Material(
          color: backgroundColor ?? colors.surfaceContainerLow,
          textStyle: context.textTheme.bodyMedium?.copyWith(
            color: foregroundColor ?? colors.onSurface,
          ),
          elevation: elevation,
          shape: shape,
          clipBehavior: Clip.antiAlias,
          child: interactiveContent,
        ),
      ),
    );
  }
}
