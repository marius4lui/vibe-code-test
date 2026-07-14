import 'package:flutter/widgets.dart';

/// Corner radii for controls, cards, and modal surfaces.
abstract final class AppRadii {
  static const double smallValue = 8;
  static const double mediumValue = 12;
  static const double largeValue = 16;
  static const double extraLargeValue = 24;
  static const double fullValue = 999;

  static const BorderRadius small = BorderRadius.all(Radius.circular(smallValue));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(mediumValue));
  static const BorderRadius large = BorderRadius.all(Radius.circular(largeValue));
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(extraLargeValue));
  static const BorderRadius full = BorderRadius.all(Radius.circular(fullValue));
}
