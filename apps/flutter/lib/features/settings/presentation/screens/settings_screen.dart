import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/core/theme/app_icon_sizes.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/atoms/app_surface.dart';
import 'package:momentum/core/widgets/error_banner.dart';
import 'package:momentum/core/widgets/section_header.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/state/app_operation.dart';
import 'package:momentum/features/settings/domain/app_theme_preference.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final projection = ref.watch(
      momentumProvider.select(
        (state) => (
          activeOperation: state.activeOperation,
          error: state.error,
          failedOperation: state.failedOperation,
          themePreference: state.preferences.themePreference,
        ),
      ),
    );
    final isSaving = projection.activeOperation == AppOperation.settings;

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: Text(l10n.settingsTitle)),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: AppLayout.contentConstraints,
              child: Padding(
                padding: AppSpacing.page,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (projection.error != null &&
                        projection.failedOperation == AppOperation.settings) ...[
                      ErrorBanner(
                        title: l10n.startupErrorTitle,
                        message: l10n.settingsSaveError,
                        dismissLabel: l10n.dismiss,
                        dismissKey: const ValueKey(AppWidgetKeys.errorDismissButton),
                        onDismiss: () => ref.read(momentumProvider.notifier).clearError(),
                      ),
                      const SizedBox(height: AppSpacing.s24),
                    ],
                    SectionHeader(title: l10n.appearanceTitle, subtitle: l10n.appearanceBody),
                    const SizedBox(height: AppSpacing.s12),
                    AppSurface(
                      child: RadioGroup<AppThemePreference>(
                        key: const ValueKey(AppWidgetKeys.settingsThemeMode),
                        groupValue: projection.themePreference,
                        onChanged: (preference) {
                          if (preference == null || isSaving) return;
                          unawaited(
                            ref.read(momentumProvider.notifier).setThemePreference(preference),
                          );
                        },
                        child: Column(
                          children: [
                            RadioListTile<AppThemePreference>(
                              enabled: !isSaving,
                              value: AppThemePreference.system,
                              secondary: const Icon(Icons.brightness_auto_outlined),
                              title: Text(l10n.themeSystem),
                            ),
                            RadioListTile<AppThemePreference>(
                              enabled: !isSaving,
                              value: AppThemePreference.light,
                              secondary: const Icon(Icons.light_mode_outlined),
                              title: Text(l10n.themeLight),
                            ),
                            RadioListTile<AppThemePreference>(
                              enabled: !isSaving,
                              value: AppThemePreference.dark,
                              secondary: const Icon(Icons.dark_mode_outlined),
                              title: Text(l10n.themeDark),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    SectionHeader(title: l10n.privacyTitle),
                    const SizedBox(height: AppSpacing.s12),
                    AppSurface(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: AppIconSizes.large,
                            color: context.colors.primary,
                          ),
                          const SizedBox(width: AppSpacing.s16),
                          Expanded(
                            child: Text(
                              l10n.privacyBody,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    SectionHeader(title: l10n.aboutTitle),
                    const SizedBox(height: AppSpacing.s12),
                    AppSurface(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.track_changes_rounded,
                          size: AppIconSizes.large,
                          color: context.colors.primary,
                        ),
                        title: Text(l10n.appName),
                        subtitle: Text(l10n.versionLabel),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s64),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
