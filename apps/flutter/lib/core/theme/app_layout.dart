import 'package:flutter/widgets.dart';

import 'package:momentum/core/theme/app_spacing.dart';

/// Shared layout constraints and Material 3 window-size breakpoints.
abstract final class AppLayout {
  static const double compactBreakpoint = 600;
  static const double expandedBreakpoint = 840;

  static const double minTouchTarget = 48;
  static const double buttonMinWidth = 64;
  static const double navigationBarHeight = 80;
  static const double maxContentWidth = 760;
  static const double maxReadingWidth = 560;
  static const double emptyStateMaxWidth = 400;
  static const double progressIndicatorSize = 40;
  static const double badgeMinHeight = 28;

  static const double borderWidth = 1;
  static const double focusedBorderWidth = 2;
  static const double progressStrokeWidth = 3;
  static const double flatElevation = 0;
  static const double floatingElevation = 3;

  static const BoxConstraints touchTargetConstraints = BoxConstraints(
    minWidth: minTouchTarget,
    minHeight: minTouchTarget,
  );
  static const BoxConstraints contentConstraints = BoxConstraints(maxWidth: maxContentWidth);
  static const BoxConstraints readingConstraints = BoxConstraints(maxWidth: maxReadingWidth);

  static const EdgeInsets dialogInsetPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.s20,
    vertical: AppSpacing.s24,
  );
}
