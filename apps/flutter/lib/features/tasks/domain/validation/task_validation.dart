enum TaskTitleValidationError { required, tooLong }

enum TaskDescriptionValidationError { tooLong }

abstract final class TaskValidation {
  static const int titleMaxLength = 80;
  static const int descriptionMaxLength = 300;

  static TaskTitleValidationError? validateTitle(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return TaskTitleValidationError.required;
    if (trimmed.length > titleMaxLength) return TaskTitleValidationError.tooLong;
    return null;
  }

  static TaskDescriptionValidationError? validateDescription(String input) {
    if (input.trim().length > descriptionMaxLength) {
      return TaskDescriptionValidationError.tooLong;
    }
    return null;
  }

  static String? normalizeOptionalDescription(String input) {
    final trimmed = input.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static bool isValidScheduledTime(Duration? value) {
    if (value == null) return true;
    return !value.isNegative && value < const Duration(days: 1);
  }
}
