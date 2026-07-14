import { TASK_PRIORITIES, type TaskDraft } from '@/models';
import { isValidLocalDate, isValidLocalTime } from '@/utils/date';

export const TASK_TITLE_MAX_LENGTH = 80;
export const TASK_DESCRIPTION_MAX_LENGTH = 500;

export interface TaskValidationErrors {
  title?: string;
  description?: string;
  categoryId?: string;
  priority?: string;
  date?: string;
  time?: string;
}

export interface TaskValidationResult {
  isValid: boolean;
  errors: TaskValidationErrors;
}

export function validateTaskDraft(
  draft: TaskDraft,
  validCategoryIds?: readonly string[],
): TaskValidationResult {
  const errors: TaskValidationErrors = {};
  const title = draft.title.trim();
  const description = draft.description?.trim() ?? '';
  const categoryId = draft.categoryId.trim();
  const time = draft.time?.trim() ?? '';

  if (!title) {
    errors.title = 'Bitte gib einen Titel ein.';
  } else if (title.length > TASK_TITLE_MAX_LENGTH) {
    errors.title = `Der Titel darf höchstens ${TASK_TITLE_MAX_LENGTH} Zeichen lang sein.`;
  }

  if (description.length > TASK_DESCRIPTION_MAX_LENGTH) {
    errors.description = `Die Beschreibung darf höchstens ${TASK_DESCRIPTION_MAX_LENGTH} Zeichen lang sein.`;
  }

  if (!categoryId) {
    errors.categoryId = 'Bitte wähle eine Kategorie aus.';
  } else if (validCategoryIds && !validCategoryIds.includes(categoryId)) {
    errors.categoryId = 'Die ausgewählte Kategorie ist nicht verfügbar.';
  }

  if (!TASK_PRIORITIES.includes(draft.priority)) {
    errors.priority = 'Bitte wähle eine gültige Priorität aus.';
  }

  if (!isValidLocalDate(draft.date)) {
    errors.date = 'Bitte wähle ein gültiges Datum aus.';
  }

  if (time && !isValidLocalTime(time)) {
    errors.time = 'Bitte gib eine gültige Uhrzeit ein.';
  }

  return {
    isValid: Object.keys(errors).length === 0,
    errors,
  };
}

export function normalizeTaskDraft(draft: TaskDraft): Required<TaskDraft> {
  const description = draft.description?.trim() ?? '';
  const time = draft.time?.trim() ?? '';

  return {
    title: draft.title.trim(),
    description: description || null,
    categoryId: draft.categoryId.trim(),
    priority: draft.priority,
    date: draft.date,
    time: time || null,
  };
}
