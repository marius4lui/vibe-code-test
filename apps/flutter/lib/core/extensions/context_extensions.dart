import 'package:flutter/material.dart';

import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_semantic_colors.dart';
import 'package:momentum/l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  AppSemanticColors get semanticColors {
    final colors = theme.extension<AppSemanticColors>();
    if (colors != null) return colors;
    return theme.brightness == Brightness.dark ? AppSemanticColors.dark : AppSemanticColors.light;
  }

  bool get isDarkMode => theme.brightness == Brightness.dark;

  bool get isCompact => MediaQuery.sizeOf(this).width < AppLayout.compactBreakpoint;

  bool get isExpanded => MediaQuery.sizeOf(this).width >= AppLayout.expandedBreakpoint;

  bool get isCurrentModalRoute {
    final isCurrent = ModalRoute.isCurrentOf(this);
    if (isCurrent == null) return true;
    return isCurrent;
  }
}
