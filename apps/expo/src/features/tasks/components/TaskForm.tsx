import { useMemo, useState } from 'react';
import {
  AccessibilityInfo,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  View,
} from 'react-native';
import DateTimePicker, { type DateTimePickerEvent } from '@react-native-community/datetimepicker';
import {
  Button,
  Chip,
  HelperText,
  Icon,
  Surface,
  Switch,
  Text,
  TextInput,
  TouchableRipple,
} from 'react-native-paper';

import {
  TASK_DESCRIPTION_MAX_LENGTH,
  TASK_TITLE_MAX_LENGTH,
  type TaskValidationErrors,
  normalizeTaskDraft,
  validateTaskDraft,
} from '@/features/tasks/validation';
import type { Category, TaskDraft, TaskPriority } from '@/models';
import { useMomentumTheme } from '@/theme/theme';
import { parseLocalDate, toLocalDateKey } from '@/utils/date';
import { formatDateInput, PRIORITY_LABELS } from '@/utils/format';

type TaskFormProps = {
  initialDraft: TaskDraft;
  categories: readonly Category[];
  submitLabel: string;
  onSubmit: (draft: TaskDraft) => void | Promise<void>;
  onDelete?: () => void;
};

const PRIORITY_ICONS: Record<TaskPriority, string> = {
  low: 'chevron-down',
  medium: 'equal',
  high: 'chevron-double-up',
};

export function TaskForm({
  initialDraft,
  categories,
  submitLabel,
  onSubmit,
  onDelete,
}: TaskFormProps) {
  const theme = useMomentumTheme();
  const [draft, setDraft] = useState<TaskDraft>(() => ({ ...initialDraft }));
  const [errors, setErrors] = useState<TaskValidationErrors>({});
  const [datePickerVisible, setDatePickerVisible] = useState(false);
  const [timePickerVisible, setTimePickerVisible] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const categoryIds = useMemo(() => categories.map((category) => category.id), [categories]);

  const updateDraft = <K extends keyof TaskDraft>(field: K, value: TaskDraft[K]) => {
    setDraft((current) => ({ ...current, [field]: value }));
    setErrors((current) => ({ ...current, [field]: undefined }));
  };

  const handleDateChange = (event: DateTimePickerEvent, selected?: Date) => {
    setDatePickerVisible(false);
    if (event.type === 'set' && selected) {
      updateDraft('date', toLocalDateKey(selected));
    }
  };

  const handleTimeChange = (event: DateTimePickerEvent, selected?: Date) => {
    setTimePickerVisible(false);
    if (event.type === 'set' && selected) {
      const hours = String(selected.getHours()).padStart(2, '0');
      const minutes = String(selected.getMinutes()).padStart(2, '0');
      updateDraft('time', `${hours}:${minutes}`);
    }
  };

  const handleSubmit = async () => {
    const result = validateTaskDraft(draft, categoryIds);
    setErrors(result.errors);

    if (!result.isValid) {
      AccessibilityInfo.announceForAccessibility(
        'Bitte prüfe die markierten Felder im Aufgabenformular.',
      );
      return;
    }

    setSubmitting(true);
    try {
      await onSubmit(normalizeTaskDraft(draft));
    } finally {
      setSubmitting(false);
    }
  };

  const selectedDate = parseLocalDate(draft.date) ?? new Date();
  const selectedTime = new Date();
  if (draft.time) {
    const [hours, minutes] = draft.time.split(':').map(Number);
    selectedTime.setHours(hours, minutes, 0, 0);
  } else {
    selectedTime.setHours(9, 0, 0, 0);
  }

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      style={[styles.flex, { backgroundColor: theme.colors.background }]}
    >
      <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scrollContent}>
        <Surface
          elevation={0}
          style={[
            styles.section,
            { backgroundColor: theme.colors.surface, borderColor: theme.colors.outlineVariant },
          ]}
        >
          <View style={styles.sectionHeader}>
            <Icon source="text-box-outline" size={20} color={theme.colors.primary} />
            <Text variant="titleMedium" style={styles.sectionTitle}>
              Details
            </Text>
          </View>

          <TextInput
            accessibilityLabel="Titel"
            autoCapitalize="sentences"
            autoFocus={!initialDraft.title}
            error={Boolean(errors.title)}
            label="Titel *"
            maxLength={TASK_TITLE_MAX_LENGTH + 20}
            mode="outlined"
            onChangeText={(value) => updateDraft('title', value)}
            returnKeyType="next"
            value={draft.title}
          />
          <View style={styles.helperRow}>
            <HelperText type="error" visible={Boolean(errors.title)} style={styles.helperText}>
              {errors.title}
            </HelperText>
            <Text variant="labelSmall" style={{ color: theme.colors.onSurfaceVariant }}>
              {draft.title.length}/{TASK_TITLE_MAX_LENGTH}
            </Text>
          </View>

          <TextInput
            accessibilityLabel="Beschreibung"
            error={Boolean(errors.description)}
            label="Beschreibung (optional)"
            maxLength={TASK_DESCRIPTION_MAX_LENGTH + 50}
            mode="outlined"
            multiline
            numberOfLines={4}
            onChangeText={(value) => updateDraft('description', value)}
            style={styles.descriptionInput}
            value={draft.description ?? ''}
          />
          <View style={styles.helperRow}>
            <HelperText
              type="error"
              visible={Boolean(errors.description)}
              style={styles.helperText}
            >
              {errors.description}
            </HelperText>
            <Text variant="labelSmall" style={{ color: theme.colors.onSurfaceVariant }}>
              {(draft.description ?? '').length}/{TASK_DESCRIPTION_MAX_LENGTH}
            </Text>
          </View>
        </Surface>

        <Surface
          elevation={0}
          style={[
            styles.section,
            { backgroundColor: theme.colors.surface, borderColor: theme.colors.outlineVariant },
          ]}
        >
          <View style={styles.sectionHeader}>
            <Icon source="shape-outline" size={20} color={theme.colors.primary} />
            <Text variant="titleMedium" style={styles.sectionTitle}>
              Kategorie
            </Text>
          </View>
          <View style={styles.chipGrid} accessibilityRole="radiogroup">
            {categories.map((category) => (
              <Chip
                key={category.id}
                accessibilityRole="radio"
                accessibilityState={{ selected: draft.categoryId === category.id }}
                icon={category.icon}
                mode={draft.categoryId === category.id ? 'flat' : 'outlined'}
                onPress={() => updateDraft('categoryId', category.id)}
                selected={draft.categoryId === category.id}
                showSelectedCheck
                style={styles.choiceChip}
              >
                {category.name}
              </Chip>
            ))}
          </View>
          <HelperText type="error" visible={Boolean(errors.categoryId)}>
            {errors.categoryId}
          </HelperText>
        </Surface>

        <Surface
          elevation={0}
          style={[
            styles.section,
            { backgroundColor: theme.colors.surface, borderColor: theme.colors.outlineVariant },
          ]}
        >
          <View style={styles.sectionHeader}>
            <Icon source="signal" size={20} color={theme.colors.primary} />
            <Text variant="titleMedium" style={styles.sectionTitle}>
              Priorität
            </Text>
          </View>
          <View style={styles.chipGrid} accessibilityRole="radiogroup">
            {(['low', 'medium', 'high'] as const).map((priority) => (
              <Chip
                key={priority}
                accessibilityRole="radio"
                accessibilityState={{ selected: draft.priority === priority }}
                icon={PRIORITY_ICONS[priority]}
                mode={draft.priority === priority ? 'flat' : 'outlined'}
                onPress={() => updateDraft('priority', priority)}
                selected={draft.priority === priority}
                showSelectedCheck
                style={styles.choiceChip}
              >
                {PRIORITY_LABELS[priority]}
              </Chip>
            ))}
          </View>
          <HelperText type="error" visible={Boolean(errors.priority)}>
            {errors.priority}
          </HelperText>
        </Surface>

        <Surface
          elevation={0}
          style={[
            styles.section,
            { backgroundColor: theme.colors.surface, borderColor: theme.colors.outlineVariant },
          ]}
        >
          <View style={styles.sectionHeader}>
            <Icon source="calendar-clock-outline" size={20} color={theme.colors.primary} />
            <Text variant="titleMedium" style={styles.sectionTitle}>
              Termin
            </Text>
          </View>

          <TouchableRipple
            accessibilityRole="button"
            accessibilityLabel={`Datum, ${formatDateInput(draft.date)}`}
            borderless
            onPress={() => setDatePickerVisible(true)}
            style={[
              styles.pickerRow,
              { borderColor: errors.date ? theme.colors.error : theme.colors.outline },
            ]}
          >
            <View style={styles.pickerContent}>
              <View>
                <Text variant="labelSmall" style={{ color: theme.colors.onSurfaceVariant }}>
                  Datum *
                </Text>
                <Text variant="bodyLarge" style={styles.pickerValue}>
                  {formatDateInput(draft.date)}
                </Text>
              </View>
              <Icon source="calendar-month-outline" size={22} color={theme.colors.primary} />
            </View>
          </TouchableRipple>
          <HelperText type="error" visible={Boolean(errors.date)}>
            {errors.date}
          </HelperText>

          <View style={styles.switchRow}>
            <View style={styles.switchLabel}>
              <Text variant="bodyLarge">Uhrzeit hinzufügen</Text>
              <Text variant="bodySmall" style={{ color: theme.colors.onSurfaceVariant }}>
                Optional für Aufgaben mit festem Termin
              </Text>
            </View>
            <Switch
              accessibilityLabel="Uhrzeit hinzufügen"
              onValueChange={(enabled) =>
                updateDraft('time', enabled ? (draft.time ?? '09:00') : null)
              }
              value={draft.time !== null && draft.time !== undefined}
            />
          </View>

          {draft.time ? (
            <TouchableRipple
              accessibilityRole="button"
              accessibilityLabel={`Uhrzeit, ${draft.time} Uhr`}
              borderless
              onPress={() => setTimePickerVisible(true)}
              style={[
                styles.pickerRow,
                { borderColor: errors.time ? theme.colors.error : theme.colors.outline },
              ]}
            >
              <View style={styles.pickerContent}>
                <View>
                  <Text variant="labelSmall" style={{ color: theme.colors.onSurfaceVariant }}>
                    Uhrzeit
                  </Text>
                  <Text variant="bodyLarge" style={styles.pickerValue}>
                    {draft.time} Uhr
                  </Text>
                </View>
                <Icon source="clock-outline" size={22} color={theme.colors.primary} />
              </View>
            </TouchableRipple>
          ) : null}
          <HelperText type="error" visible={Boolean(errors.time)}>
            {errors.time}
          </HelperText>
        </Surface>

        <Button
          accessibilityLabel={submitLabel}
          contentStyle={styles.submitContent}
          icon="check"
          loading={submitting}
          mode="contained"
          onPress={() => void handleSubmit()}
          disabled={submitting}
        >
          {submitLabel}
        </Button>

        {onDelete ? (
          <Button
            accessibilityLabel="Aufgabe löschen"
            icon="delete-outline"
            mode="text"
            onPress={onDelete}
            textColor={theme.colors.error}
            style={styles.deleteButton}
          >
            Aufgabe löschen
          </Button>
        ) : null}
      </ScrollView>

      {datePickerVisible ? (
        <DateTimePicker
          mode="date"
          display="default"
          value={selectedDate}
          onChange={handleDateChange}
        />
      ) : null}
      {timePickerVisible ? (
        <DateTimePicker
          mode="time"
          display="default"
          value={selectedTime}
          onChange={handleTimeChange}
          is24Hour
        />
      ) : null}
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  choiceChip: {
    minHeight: 44,
  },
  chipGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 10,
  },
  deleteButton: {
    alignSelf: 'center',
    marginBottom: 8,
    marginTop: 4,
  },
  descriptionInput: {
    minHeight: 112,
  },
  flex: {
    flex: 1,
  },
  helperRow: {
    alignItems: 'center',
    flexDirection: 'row',
    minHeight: 34,
  },
  helperText: {
    flex: 1,
  },
  pickerContent: {
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 10,
  },
  pickerRow: {
    borderRadius: 12,
    borderWidth: 1,
    minHeight: 64,
    overflow: 'hidden',
  },
  pickerValue: {
    marginTop: 3,
  },
  scrollContent: {
    alignSelf: 'center',
    gap: 16,
    maxWidth: 760,
    paddingBottom: 40,
    paddingHorizontal: 16,
    paddingTop: 16,
    width: '100%',
  },
  section: {
    borderRadius: 20,
    borderWidth: 1,
    padding: 16,
  },
  sectionHeader: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 9,
    marginBottom: 16,
  },
  sectionTitle: {
    fontWeight: '700',
  },
  submitContent: {
    minHeight: 52,
  },
  switchLabel: {
    flex: 1,
    gap: 2,
  },
  switchRow: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 16,
    justifyContent: 'space-between',
    minHeight: 64,
    paddingVertical: 8,
  },
});
