import 'package:flutter/animation.dart';

/// Purposeful, short motion tokens that respect Material motion conventions.
abstract final class AppMotion {
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration standard = Duration(milliseconds: 120);
  static const Duration emphasized = Duration(milliseconds: 120);
  static const Duration pageTransition = Duration(milliseconds: 120);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve standardCurve = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Curves.easeOutBack;
}
