import 'package:flutter/material.dart';

/// Non-Material color semantics used for task status, priority, and category.
final class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.priorityLow,
    required this.priorityLowContainer,
    required this.priorityMedium,
    required this.priorityMediumContainer,
    required this.priorityHigh,
    required this.priorityHighContainer,
    required this.categoryWork,
    required this.categoryWorkContainer,
    required this.categoryPersonal,
    required this.categoryPersonalContainer,
    required this.categoryHealth,
    required this.categoryHealthContainer,
    required this.categoryLearning,
    required this.categoryLearningContainer,
  });

  static const AppSemanticColors light = AppSemanticColors(
    success: Color(0xFF176B3A),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFD0F8DB),
    onSuccessContainer: Color(0xFF06210F),
    priorityLow: Color(0xFF42674D),
    priorityLowContainer: Color(0xFFD9F1DE),
    priorityMedium: Color(0xFF765800),
    priorityMediumContainer: Color(0xFFFFE08A),
    priorityHigh: Color(0xFFA23B30),
    priorityHighContainer: Color(0xFFFFDAD5),
    categoryWork: Color(0xFF355C8A),
    categoryWorkContainer: Color(0xFFD5E3FF),
    categoryPersonal: Color(0xFF77528A),
    categoryPersonalContainer: Color(0xFFF5D9FF),
    categoryHealth: Color(0xFF23705B),
    categoryHealthContainer: Color(0xFFC0F0DD),
    categoryLearning: Color(0xFF765800),
    categoryLearningContainer: Color(0xFFFFE08B),
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: Color(0xFF8DDAA4),
    onSuccess: Color(0xFF00391B),
    successContainer: Color(0xFF0B5229),
    onSuccessContainer: Color(0xFFAAF7BF),
    priorityLow: Color(0xFFA8D1B5),
    priorityLowContainer: Color(0xFF274B34),
    priorityMedium: Color(0xFFF7C75B),
    priorityMediumContainer: Color(0xFF5C4300),
    priorityHigh: Color(0xFFFFB4AA),
    priorityHighContainer: Color(0xFF7E2C24),
    categoryWork: Color(0xFFA9C7F5),
    categoryWorkContainer: Color(0xFF244366),
    categoryPersonal: Color(0xFFE7B5F5),
    categoryPersonalContainer: Color(0xFF5D3A6D),
    categoryHealth: Color(0xFF91D5C0),
    categoryHealthContainer: Color(0xFF07513E),
    categoryLearning: Color(0xFFF7C75B),
    categoryLearningContainer: Color(0xFF5C4300),
  );

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color priorityLow;
  final Color priorityLowContainer;
  final Color priorityMedium;
  final Color priorityMediumContainer;
  final Color priorityHigh;
  final Color priorityHighContainer;
  final Color categoryWork;
  final Color categoryWorkContainer;
  final Color categoryPersonal;
  final Color categoryPersonalContainer;
  final Color categoryHealth;
  final Color categoryHealthContainer;
  final Color categoryLearning;
  final Color categoryLearningContainer;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? priorityLow,
    Color? priorityLowContainer,
    Color? priorityMedium,
    Color? priorityMediumContainer,
    Color? priorityHigh,
    Color? priorityHighContainer,
    Color? categoryWork,
    Color? categoryWorkContainer,
    Color? categoryPersonal,
    Color? categoryPersonalContainer,
    Color? categoryHealth,
    Color? categoryHealthContainer,
    Color? categoryLearning,
    Color? categoryLearningContainer,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      priorityLow: priorityLow ?? this.priorityLow,
      priorityLowContainer: priorityLowContainer ?? this.priorityLowContainer,
      priorityMedium: priorityMedium ?? this.priorityMedium,
      priorityMediumContainer: priorityMediumContainer ?? this.priorityMediumContainer,
      priorityHigh: priorityHigh ?? this.priorityHigh,
      priorityHighContainer: priorityHighContainer ?? this.priorityHighContainer,
      categoryWork: categoryWork ?? this.categoryWork,
      categoryWorkContainer: categoryWorkContainer ?? this.categoryWorkContainer,
      categoryPersonal: categoryPersonal ?? this.categoryPersonal,
      categoryPersonalContainer: categoryPersonalContainer ?? this.categoryPersonalContainer,
      categoryHealth: categoryHealth ?? this.categoryHealth,
      categoryHealthContainer: categoryHealthContainer ?? this.categoryHealthContainer,
      categoryLearning: categoryLearning ?? this.categoryLearning,
      categoryLearningContainer: categoryLearningContainer ?? this.categoryLearningContainer,
    );
  }

  @override
  AppSemanticColors lerp(covariant AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      success: _lerpColor(success, other.success, t),
      onSuccess: _lerpColor(onSuccess, other.onSuccess, t),
      successContainer: _lerpColor(successContainer, other.successContainer, t),
      onSuccessContainer: _lerpColor(onSuccessContainer, other.onSuccessContainer, t),
      priorityLow: _lerpColor(priorityLow, other.priorityLow, t),
      priorityLowContainer: _lerpColor(priorityLowContainer, other.priorityLowContainer, t),
      priorityMedium: _lerpColor(priorityMedium, other.priorityMedium, t),
      priorityMediumContainer: _lerpColor(
        priorityMediumContainer,
        other.priorityMediumContainer,
        t,
      ),
      priorityHigh: _lerpColor(priorityHigh, other.priorityHigh, t),
      priorityHighContainer: _lerpColor(priorityHighContainer, other.priorityHighContainer, t),
      categoryWork: _lerpColor(categoryWork, other.categoryWork, t),
      categoryWorkContainer: _lerpColor(categoryWorkContainer, other.categoryWorkContainer, t),
      categoryPersonal: _lerpColor(categoryPersonal, other.categoryPersonal, t),
      categoryPersonalContainer: _lerpColor(
        categoryPersonalContainer,
        other.categoryPersonalContainer,
        t,
      ),
      categoryHealth: _lerpColor(categoryHealth, other.categoryHealth, t),
      categoryHealthContainer: _lerpColor(
        categoryHealthContainer,
        other.categoryHealthContainer,
        t,
      ),
      categoryLearning: _lerpColor(categoryLearning, other.categoryLearning, t),
      categoryLearningContainer: _lerpColor(
        categoryLearningContainer,
        other.categoryLearningContainer,
        t,
      ),
    );
  }

  static Color _lerpColor(Color from, Color to, double t) {
    final result = Color.lerp(from, to, t);
    if (result == null) return from;
    return result;
  }
}
