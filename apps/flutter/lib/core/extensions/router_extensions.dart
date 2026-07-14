import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension TypedRouteNavigation on BuildContext {
  bool popIfCan<T extends Object?>([T? result]) {
    if (!mounted) return false;
    final rootNavigator = Navigator.maybeOf(this, rootNavigator: true);
    if (rootNavigator != null && rootNavigator.canPop()) {
      rootNavigator.pop<T>(result);
      return true;
    }

    final navigator = Navigator.maybeOf(this);
    if (navigator != null && navigator.canPop()) {
      navigator.pop<T>(result);
      return true;
    }

    if (!canPop()) return false;
    pop<T>(result);
    return true;
  }

  void popOrGo<T extends Object?>(GoRouteData fallbackRoute, [T? result]) {
    if (popIfCan<T>(result)) return;
    fallbackRoute.go(this);
  }
}
