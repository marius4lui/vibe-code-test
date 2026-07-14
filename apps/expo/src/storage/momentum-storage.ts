import {
  MOMENTUM_SCHEMA_VERSION,
  TASK_PRIORITIES,
  THEME_MODES,
  type Category,
  type CategoryColor,
  type MomentumData,
  type MomentumSettings,
  type PersistedMomentumState,
  type Task,
  type TaskPriority,
} from '@/models';
import { isValidLocalDate, isValidLocalTime } from '@/utils/date';

import type { StorageAdapter } from './storage-adapter';

export const MOMENTUM_STORAGE_KEY = '@momentum/state:v1';

const CATEGORY_COLORS: readonly CategoryColor[] = ['indigo', 'cyan', 'green', 'amber'];

export class MomentumStorageError extends Error {
  constructor(message: string, options?: ErrorOptions) {
    super(message, options);
    this.name = 'MomentumStorageError';
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isIsoDate(value: unknown): value is string {
  return typeof value === 'string' && !Number.isNaN(new Date(value).getTime());
}

function parseCategory(value: unknown): Category {
  if (!isRecord(value)) {
    throw new MomentumStorageError('Eine gespeicherte Kategorie ist beschädigt.');
  }

  const { id, name, icon, color } = value;

  if (
    typeof id !== 'string' ||
    !id ||
    typeof name !== 'string' ||
    !name ||
    typeof icon !== 'string' ||
    !icon ||
    !CATEGORY_COLORS.some((candidate) => candidate === color)
  ) {
    throw new MomentumStorageError('Eine gespeicherte Kategorie ist ungültig.');
  }

  return { id, name, icon, color: color as CategoryColor };
}

function parseTask(value: unknown): Task {
  if (!isRecord(value)) {
    throw new MomentumStorageError('Eine gespeicherte Aufgabe ist beschädigt.');
  }

  const {
    id,
    title,
    description,
    categoryId,
    priority,
    date,
    time,
    completedAt,
    createdAt,
    updatedAt,
  } = value;

  if (
    typeof id !== 'string' ||
    !id ||
    typeof title !== 'string' ||
    !title.trim() ||
    (description !== null && typeof description !== 'string') ||
    typeof categoryId !== 'string' ||
    !categoryId ||
    !TASK_PRIORITIES.some((candidate) => candidate === priority) ||
    typeof date !== 'string' ||
    !isValidLocalDate(date) ||
    (time !== null && (typeof time !== 'string' || !isValidLocalTime(time))) ||
    (completedAt !== null && !isIsoDate(completedAt)) ||
    !isIsoDate(createdAt) ||
    !isIsoDate(updatedAt)
  ) {
    throw new MomentumStorageError('Eine gespeicherte Aufgabe ist ungültig.');
  }

  return {
    id,
    title,
    description: description as string | null,
    categoryId,
    priority: priority as TaskPriority,
    date,
    time: time as string | null,
    completedAt: completedAt as string | null,
    createdAt,
    updatedAt,
  };
}

function parseSettings(value: unknown): MomentumSettings {
  if (!isRecord(value)) {
    throw new MomentumStorageError('Die gespeicherten Einstellungen sind beschädigt.');
  }

  const { themeMode, onboardingCompleted } = value;

  if (
    !THEME_MODES.some((candidate) => candidate === themeMode) ||
    typeof onboardingCompleted !== 'boolean'
  ) {
    throw new MomentumStorageError('Die gespeicherten Einstellungen sind ungültig.');
  }

  return {
    themeMode: themeMode as MomentumSettings['themeMode'],
    onboardingCompleted,
  };
}

function parseMomentumData(value: unknown): MomentumData {
  if (!isRecord(value)) {
    throw new MomentumStorageError('Die gespeicherten App-Daten sind beschädigt.');
  }

  const { tasks, categories, settings, didSeed, seededAt } = value;

  if (!Array.isArray(tasks) || !Array.isArray(categories)) {
    throw new MomentumStorageError('Aufgaben oder Kategorien konnten nicht gelesen werden.');
  }

  if (typeof didSeed !== 'boolean' || (seededAt !== null && !isIsoDate(seededAt))) {
    throw new MomentumStorageError('Die Startdaten-Metadaten sind ungültig.');
  }

  const parsedCategories = categories.map(parseCategory);
  const parsedTasks = tasks.map(parseTask);
  const categoryIds = new Set(parsedCategories.map((category) => category.id));
  const taskIds = new Set(parsedTasks.map((task) => task.id));

  if (categoryIds.size !== parsedCategories.length) {
    throw new MomentumStorageError('Gespeicherte Kategorien enthalten doppelte IDs.');
  }

  if (taskIds.size !== parsedTasks.length) {
    throw new MomentumStorageError('Gespeicherte Aufgaben enthalten doppelte IDs.');
  }

  if (parsedTasks.some((task) => !categoryIds.has(task.categoryId))) {
    throw new MomentumStorageError('Eine Aufgabe verweist auf eine unbekannte Kategorie.');
  }

  return {
    tasks: parsedTasks,
    categories: parsedCategories,
    settings: parseSettings(settings),
    didSeed,
    seededAt: seededAt as string | null,
  };
}

export function serializeMomentumData(data: MomentumData): string {
  const persistedState: PersistedMomentumState = {
    version: MOMENTUM_SCHEMA_VERSION,
    data,
  };

  return JSON.stringify(persistedState);
}

export function deserializeMomentumData(serialized: string): MomentumData {
  let parsed: unknown;

  try {
    parsed = JSON.parse(serialized) as unknown;
  } catch (error) {
    throw new MomentumStorageError('Die lokalen Daten sind kein gültiges JSON.', {
      cause: error,
    });
  }

  if (!isRecord(parsed) || parsed.version !== MOMENTUM_SCHEMA_VERSION) {
    throw new MomentumStorageError('Die gespeicherte Datenversion wird nicht unterstützt.');
  }

  return parseMomentumData(parsed.data);
}

export async function loadMomentumData(storage: StorageAdapter): Promise<MomentumData | null> {
  const serialized = await storage.getItem(MOMENTUM_STORAGE_KEY);
  return serialized === null ? null : deserializeMomentumData(serialized);
}

export async function saveMomentumData(storage: StorageAdapter, data: MomentumData): Promise<void> {
  await storage.setItem(MOMENTUM_STORAGE_KEY, serializeMomentumData(data));
}

export async function removeMomentumData(storage: StorageAdapter): Promise<void> {
  await storage.removeItem(MOMENTUM_STORAGE_KEY);
}
