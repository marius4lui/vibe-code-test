import 'package:flutter/material.dart';

import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_radii.dart';
import 'package:momentum/core/theme/app_semantic_colors.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/theme/app_typography.dart';

/// Material 3 themes for Momentum's light and dark appearances.
abstract final class AppTheme {
  static const Color _brandSeed = Color(0xFF006B5C);
  static const Color _lightSurface = Color(0xFFF8FAF7);
  static const Color _darkSurface = Color(0xFF101412);

  static final ThemeData light = _build(
    brightness: Brightness.light,
    surface: _lightSurface,
    semanticColors: AppSemanticColors.light,
  );

  static final ThemeData dark = _build(
    brightness: Brightness.dark,
    surface: _darkSurface,
    semanticColors: AppSemanticColors.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color surface,
    required AppSemanticColors semanticColors,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _brandSeed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ).copyWith(surface: surface);
    final textTheme = AppTypography.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      decorationColor: scheme.onSurface,
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: AppRadii.medium,
      borderSide: BorderSide(color: scheme.outlineVariant),
    );
    const controlShape = RoundedRectangleBorder(borderRadius: AppRadii.medium);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      textTheme: textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: [semanticColors],
      appBarTheme: AppBarTheme(
        elevation: AppLayout.flatElevation,
        scrolledUnderElevation: AppLayout.flatElevation,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        surfaceTintColor: scheme.surfaceTint,
        elevation: AppLayout.flatElevation,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.large,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppLayout.navigationBarHeight,
        elevation: AppLayout.flatElevation,
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          final isSelected = states.contains(WidgetState.selected);
          return AppTypography.labelMedium.copyWith(
            color: isSelected ? scheme.onSurface : scheme.onSurfaceVariant,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: AppSpacing.control,
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder.copyWith(borderSide: BorderSide(color: scheme.outlineVariant)),
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: AppLayout.focusedBorderWidth),
        ),
        errorBorder: inputBorder.copyWith(borderSide: BorderSide(color: scheme.error)),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error, width: AppLayout.focusedBorderWidth),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(AppLayout.buttonMinWidth, AppLayout.minTouchTarget),
          padding: AppSpacing.control,
          textStyle: AppTypography.labelLarge,
          shape: controlShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(AppLayout.buttonMinWidth, AppLayout.minTouchTarget),
          padding: AppSpacing.control,
          textStyle: AppTypography.labelLarge,
          shape: controlShape,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppLayout.buttonMinWidth, AppLayout.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          textStyle: AppTypography.labelLarge,
          shape: controlShape,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppLayout.minTouchTarget),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.full),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppLayout.floatingElevation,
        focusElevation: AppLayout.floatingElevation,
        hoverElevation: AppLayout.floatingElevation,
        highlightElevation: AppLayout.floatingElevation,
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.large),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.small),
        side: BorderSide(color: scheme.outline, width: AppLayout.focusedBorderWidth),
      ),
      chipTheme: ChipThemeData(
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.full),
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
        labelStyle: textTheme.labelMedium,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        circularTrackColor: scheme.surfaceContainerHighest,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: AppLayout.borderWidth,
        space: AppLayout.borderWidth,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: scheme.surfaceTint,
        elevation: AppLayout.floatingElevation,
        insetPadding: AppLayout.dialogInsetPadding,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.extraLarge),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.extraLargeValue)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        actionTextColor: scheme.inversePrimary,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.medium),
      ),
    );
  }
}
