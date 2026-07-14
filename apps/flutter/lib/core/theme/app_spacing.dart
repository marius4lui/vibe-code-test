import 'package:flutter/widgets.dart';

/// The spacing scale used throughout Momentum.
abstract final class AppSpacing {
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s64 = 64;

  static const EdgeInsets page = EdgeInsets.fromLTRB(s20, s16, s20, s32);
  static const EdgeInsets pageWide = EdgeInsets.fromLTRB(s32, s24, s32, s40);
  static const EdgeInsets card = EdgeInsets.all(s16);
  static const EdgeInsets control = EdgeInsets.symmetric(horizontal: s16, vertical: s12);
}
