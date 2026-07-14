import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/tasks/domain/validation/task_validation.dart';
import 'package:momentum/features/tasks/domain/values/task_title.dart';

void main() {
  group('TaskValidation', () {
    test('rejects blank and overlong titles', () {
      expect(TaskValidation.validateTitle('   '), equals(TaskTitleValidationError.required));
      expect(
        TaskValidation.validateTitle('x' * (TaskValidation.titleMaxLength + 1)),
        equals(TaskTitleValidationError.tooLong),
      );
    });

    test('normalizes valid form values', () {
      expect(TaskTitle('  Wochenplanung  ').value, equals('Wochenplanung'));
      expect(TaskValidation.normalizeOptionalDescription('   '), isNull);
      expect(
        TaskValidation.normalizeOptionalDescription('  Nächste Schritte festlegen  '),
        equals('Nächste Schritte festlegen'),
      );
      expect(TaskValidation.isValidScheduledTime(const Duration(hours: 23, minutes: 59)), isTrue);
      expect(TaskValidation.isValidScheduledTime(const Duration(days: 1)), isFalse);
    });
  });
}
