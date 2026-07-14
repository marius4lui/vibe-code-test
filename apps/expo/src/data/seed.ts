import type { MomentumData, Task } from '@/models';
import { DEFAULT_SETTINGS } from '@/models';
import { addLocalDays, toLocalDateKey } from '@/utils/date';
import { createId, type IdFactory } from '@/utils/id';

import { CATEGORY_IDS, createDefaultCategories } from './categories';

function makeSeedTask(
  values: Pick<
    Task,
    'title' | 'description' | 'categoryId' | 'priority' | 'date' | 'time' | 'completedAt'
  >,
  nowIso: string,
  idFactory: IdFactory,
): Task {
  return {
    id: idFactory(),
    ...values,
    createdAt: nowIso,
    updatedAt: values.completedAt ?? nowIso,
  };
}

export function createSeededMomentumData(
  now: Date = new Date(),
  idFactory: IdFactory = createId,
): MomentumData {
  const nowIso = now.toISOString();
  const today = toLocalDateKey(now);
  const yesterdayDate = addLocalDays(now, -1);
  const yesterday = toLocalDateKey(yesterdayDate);
  const tomorrow = toLocalDateKey(addLocalDays(now, 1));
  const yesterdayCompletion = new Date(yesterdayDate);

  yesterdayCompletion.setHours(18, 0, 0, 0);

  const tasks: Task[] = [
    makeSeedTask(
      {
        title: 'Tagesrückblick notieren',
        description: 'Drei Dinge festhalten, die gut gelaufen sind.',
        categoryId: CATEGORY_IDS.personal,
        priority: 'low',
        date: yesterday,
        time: '18:00',
        completedAt: yesterdayCompletion.toISOString(),
      },
      nowIso,
      idFactory,
    ),
    makeSeedTask(
      {
        title: 'Wasserflasche auffüllen',
        description: null,
        categoryId: CATEGORY_IDS.health,
        priority: 'low',
        date: today,
        time: null,
        completedAt: nowIso,
      },
      nowIso,
      idFactory,
    ),
    makeSeedTask(
      {
        title: 'Tagesplanung abschließen',
        description: 'Die drei wichtigsten Ergebnisse für heute festlegen.',
        categoryId: CATEGORY_IDS.work,
        priority: 'high',
        date: today,
        time: '09:00',
        completedAt: null,
      },
      nowIso,
      idFactory,
    ),
    makeSeedTask(
      {
        title: '30 Minuten spazieren',
        description: 'Eine bewusste Pause ohne Bildschirm einlegen.',
        categoryId: CATEGORY_IDS.health,
        priority: 'medium',
        date: today,
        time: null,
        completedAt: null,
      },
      nowIso,
      idFactory,
    ),
    makeSeedTask(
      {
        title: 'Notizen ordnen',
        description: null,
        categoryId: CATEGORY_IDS.learning,
        priority: 'low',
        date: today,
        time: '18:00',
        completedAt: null,
      },
      nowIso,
      idFactory,
    ),
    makeSeedTask(
      {
        title: 'Wochenrückblick vorbereiten',
        description: 'Offene Punkte sammeln und nächste Schritte priorisieren.',
        categoryId: CATEGORY_IDS.work,
        priority: 'high',
        date: tomorrow,
        time: '10:00',
        completedAt: null,
      },
      nowIso,
      idFactory,
    ),
  ];

  return {
    tasks,
    categories: createDefaultCategories(),
    settings: { ...DEFAULT_SETTINGS },
    didSeed: true,
    seededAt: nowIso,
  };
}

export function ensureMomentumDataIsSeeded(
  data: MomentumData,
  now: Date = new Date(),
  idFactory: IdFactory = createId,
): MomentumData {
  if (data.didSeed) {
    return data;
  }

  const seed = createSeededMomentumData(now, idFactory);

  return {
    ...data,
    tasks: [...data.tasks, ...seed.tasks],
    categories: data.categories.length > 0 ? data.categories : seed.categories,
    didSeed: true,
    seededAt: seed.seededAt,
  };
}

/**
 * Produces a clean factory-reset state without recreating demo tasks.
 * `didSeed` deliberately remains true so that an empty task list is respected.
 */
export function createResetMomentumData(
  now: Date = new Date(),
  previousSeededAt: string | null = null,
): MomentumData {
  return {
    tasks: [],
    categories: createDefaultCategories(),
    settings: { ...DEFAULT_SETTINGS },
    didSeed: true,
    seededAt: previousSeededAt ?? now.toISOString(),
  };
}
