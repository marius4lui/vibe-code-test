import { CATEGORY_IDS } from '@/data/categories';
import type { TaskDraft } from '@/models';

import { TASK_DESCRIPTION_MAX_LENGTH, validateTaskDraft } from '../validation';

const validDraft: TaskDraft = {
  title: 'Wochenplanung abschließen',
  description: 'Die wichtigsten Aufgaben für diese Woche festlegen.',
  categoryId: CATEGORY_IDS.work,
  priority: 'high',
  date: '2026-07-14',
  time: '09:30',
};

describe('validateTaskDraft', () => {
  it('accepts a complete, valid task draft', () => {
    const result = validateTaskDraft(validDraft, Object.values(CATEGORY_IDS));

    expect(result).toEqual({
      isValid: true,
      errors: {},
    });
  });

  it('reports all invalid form fields in one validation pass', () => {
    const invalidDraft: TaskDraft = {
      ...validDraft,
      title: '   ',
      description: 'x'.repeat(TASK_DESCRIPTION_MAX_LENGTH + 1),
      categoryId: 'missing-category',
      priority: 'urgent' as TaskDraft['priority'],
      date: '2026-02-30',
      time: '24:00',
    };

    const result = validateTaskDraft(invalidDraft, Object.values(CATEGORY_IDS));

    expect(result.isValid).toBe(false);
    expect(result.errors).toMatchObject({
      title: expect.any(String),
      description: expect.any(String),
      categoryId: expect.any(String),
      priority: expect.any(String),
      date: expect.any(String),
      time: expect.any(String),
    });
  });
});
