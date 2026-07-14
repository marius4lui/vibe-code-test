import 'package:flutter/material.dart';

import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_icon_sizes.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_radii.dart';
import 'package:momentum/core/theme/app_spacing.dart';

/// A calm, responsive empty state with an optional primary recovery action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.actionKey,
  }) : assert((actionLabel == null) == (onAction == null));

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: SingleChildScrollView(
        padding: AppSpacing.page,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppLayout.emptyStateMaxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s20),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: AppRadii.extraLarge,
                  ),
                  child: Icon(icon, size: AppIconSizes.hero, color: colors.onPrimaryContainer),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Semantics(
                header: true,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
              ),
              if ((label: actionLabel, action: onAction) case (
                label: final String visibleActionLabel,
                action: final VoidCallback action,
              )) ...[
                const SizedBox(height: AppSpacing.s24),
                FilledButton(key: actionKey, onPressed: action, child: Text(visibleActionLabel)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
