import type { Task } from '@/models';

import { createInitialMomentumState, momentumReducer } from '../momentum-reducer';

const task: Task = {
  id: 'task-weekly-review',
  title: 'Wochenrückblick schreiben',
  description: 'Fortschritt und nächste Schritte festhalten.',
  categoryId: 'work',
  priority: 'medium',
  date: '2026-07-14',
  time: '17:00',
  completedAt: null,
  createdAt: '2026-07-14T08:00:00.000Z',
  updatedAt: '2026-07-14T08:00:00.000Z',
};

describe('momentumReducer task lifecycle', () => {
  it('creates, completes, and reopens a task without mutating previous states', () => {
    const initialState = createInitialMomentumState();

    const createdState = momentumReducer(initialState, {
      type: 'task/create',
      task,
    });

    expect(initialState.tasks).toEqual([]);
    expect(createdState.tasks).toEqual([task]);
    expect(createdState.revision).toBe(1);

    const completedAt = '2026-07-14T18:00:00.000Z';
    const completedState = momentumReducer(createdState, {
      type: 'task/toggle',
      id: task.id,
      nowIso: completedAt,
    });

    expect(createdState.tasks[0]).toMatchObject({
      completedAt: null,
      updatedAt: task.updatedAt,
    });
    expect(completedState.tasks[0]).toMatchObject({
      id: task.id,
      completedAt,
      updatedAt: completedAt,
    });
    expect(completedState.revision).toBe(2);

    const reopenedAt = '2026-07-14T18:05:00.000Z';
    const reopenedState = momentumReducer(completedState, {
      type: 'task/toggle',
      id: task.id,
      nowIso: reopenedAt,
    });

    expect(completedState.tasks[0]?.completedAt).toBe(completedAt);
    expect(reopenedState.tasks[0]).toMatchObject({
      id: task.id,
      completedAt: null,
      updatedAt: reopenedAt,
    });
    expect(reopenedState.revision).toBe(3);
  });
});
