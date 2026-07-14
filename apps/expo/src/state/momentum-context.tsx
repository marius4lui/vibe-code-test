import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useReducer,
  useRef,
  type PropsWithChildren,
} from 'react';

import {
  createResetMomentumData,
  createSeededMomentumData,
  ensureMomentumDataIsSeeded,
} from '@/data';
import type { Task, TaskDraft, TaskPatch, ThemeMode } from '@/models';
import {
  normalizeTaskDraft,
  validateTaskDraft,
  type TaskValidationErrors,
} from '@/features/tasks/validation';
import {
  asyncStorageAdapter,
  loadMomentumData,
  saveMomentumData,
  type StorageAdapter,
} from '@/storage';
import { createId, type IdFactory } from '@/utils/id';

import {
  createInitialMomentumState,
  momentumDataFromState,
  momentumReducer,
  type MomentumReducerAction,
  type MomentumState,
} from './momentum-reducer';

const defaultNow = (): Date => new Date();

export type TaskMutationResult =
  | { ok: true; task: Task }
  | { ok: false; reason: 'validation'; errors: TaskValidationErrors }
  | { ok: false; reason: 'not-found' };

export interface MomentumActions {
  createTask(draft: TaskDraft): TaskMutationResult;
  updateTask(id: string, patch: TaskPatch): TaskMutationResult;
  toggleTask(id: string): Task | null;
  deleteTask(id: string): boolean;
  completeOnboarding(): void;
  setOnboardingCompleted(completed: boolean): void;
  setThemeMode(themeMode: ThemeMode): void;
  deleteCompleted(): number;
  resetData(): void;
  retryLoad(): Promise<void>;
  retryPersistence(): Promise<void>;
  clearPersistenceError(): void;
}

export interface MomentumContextValue {
  state: MomentumState;
  actions: MomentumActions;
}

export interface MomentumProviderProps extends PropsWithChildren {
  storage?: StorageAdapter;
  now?: () => Date;
  idFactory?: IdFactory;
}

const MomentumContext = createContext<MomentumContextValue | null>(null);

function errorDetail(error: unknown): string | null {
  if (!(error instanceof Error)) return null;
  const message = error.message.trim();
  return message || null;
}

function loadErrorMessage(error: unknown): string {
  const detail = errorDetail(error);
  return detail
    ? `Deine lokalen Daten konnten nicht geladen werden. ${detail}`
    : 'Deine lokalen Daten konnten nicht geladen werden. Bitte versuche es erneut.';
}

function persistenceErrorMessage(error: unknown): string {
  const detail = errorDetail(error);
  return detail
    ? `Die Änderungen konnten nicht lokal gespeichert werden. ${detail}`
    : 'Die Änderungen konnten nicht lokal gespeichert werden. Bitte versuche es erneut.';
}

export function MomentumProvider({
  children,
  storage = asyncStorageAdapter,
  now = defaultNow,
  idFactory = createId,
}: MomentumProviderProps) {
  const [state, reactDispatch] = useReducer(momentumReducer, undefined, createInitialMomentumState);
  const stateRef = useRef(state);
  const mountedRef = useRef(false);
  const hydrationRequestRef = useRef(0);
  const scheduledRevisionRef = useRef(0);
  const persistenceQueueRef = useRef<Promise<void>>(Promise.resolve());

  const dispatch = useCallback((action: MomentumReducerAction) => {
    stateRef.current = momentumReducer(stateRef.current, action);
    reactDispatch(action);
  }, []);

  const enqueuePersistence = useCallback(
    (snapshot: ReturnType<typeof momentumDataFromState>, revision: number): Promise<void> => {
      dispatch({ type: 'persistence/start', revision });

      const operation = persistenceQueueRef.current
        .catch(() => undefined)
        .then(() => saveMomentumData(storage, snapshot));

      persistenceQueueRef.current = operation.catch(() => undefined);

      return operation.then(
        () => {
          if (mountedRef.current) {
            dispatch({ type: 'persistence/success', revision });
          }
        },
        (error: unknown) => {
          if (mountedRef.current) {
            dispatch({
              type: 'persistence/error',
              revision,
              message: persistenceErrorMessage(error),
            });
          }
        },
      );
    },
    [dispatch, storage],
  );

  const hydrate = useCallback(async (): Promise<void> => {
    const requestId = ++hydrationRequestRef.current;
    dispatch({ type: 'app/hydrateStart' });

    try {
      const storedData = await loadMomentumData(storage);
      const hydratedData = storedData
        ? ensureMomentumDataIsSeeded(storedData, now(), idFactory)
        : createSeededMomentumData(now(), idFactory);

      if (!mountedRef.current || requestId !== hydrationRequestRef.current) return;

      scheduledRevisionRef.current = 0;
      dispatch({ type: 'app/hydrateSuccess', data: hydratedData });
    } catch (error) {
      if (!mountedRef.current || requestId !== hydrationRequestRef.current) return;
      dispatch({ type: 'app/hydrateError', message: loadErrorMessage(error) });
    }
  }, [dispatch, idFactory, now, storage]);

  useEffect(() => {
    mountedRef.current = true;
    void hydrate();

    return () => {
      mountedRef.current = false;
      hydrationRequestRef.current += 1;
    };
  }, [hydrate]);

  useEffect(() => {
    if (
      state.status !== 'ready' ||
      state.revision <= scheduledRevisionRef.current ||
      state.revision <= state.persistedRevision
    ) {
      return;
    }

    const revision = state.revision;
    scheduledRevisionRef.current = revision;
    void enqueuePersistence(momentumDataFromState(state), revision);
  }, [enqueuePersistence, state]);

  const createTask = useCallback(
    (draft: TaskDraft): TaskMutationResult => {
      const currentState = stateRef.current;
      const categoryIds = currentState.categories.map((category) => category.id);
      const validation = validateTaskDraft(draft, categoryIds);

      if (!validation.isValid) {
        return { ok: false, reason: 'validation', errors: validation.errors };
      }

      const normalized = normalizeTaskDraft(draft);
      const timestamp = now().toISOString();
      let id = idFactory();

      if (currentState.tasks.some((task) => task.id === id)) {
        id = createId();
      }

      const task: Task = {
        id,
        ...normalized,
        createdAt: timestamp,
        updatedAt: timestamp,
        completedAt: null,
      };

      dispatch({ type: 'task/create', task });
      return { ok: true, task };
    },
    [dispatch, idFactory, now],
  );

  const updateTask = useCallback(
    (id: string, patch: TaskPatch): TaskMutationResult => {
      const currentState = stateRef.current;
      const existingTask = currentState.tasks.find((task) => task.id === id);

      if (!existingTask) {
        return { ok: false, reason: 'not-found' };
      }

      const draft: TaskDraft = {
        title: patch.title ?? existingTask.title,
        description: patch.description === undefined ? existingTask.description : patch.description,
        categoryId: patch.categoryId ?? existingTask.categoryId,
        priority: patch.priority ?? existingTask.priority,
        date: patch.date ?? existingTask.date,
        time: patch.time === undefined ? existingTask.time : patch.time,
      };
      const validation = validateTaskDraft(
        draft,
        currentState.categories.map((category) => category.id),
      );

      if (!validation.isValid) {
        return { ok: false, reason: 'validation', errors: validation.errors };
      }

      const task: Task = {
        ...existingTask,
        ...normalizeTaskDraft(draft),
        updatedAt: now().toISOString(),
      };

      dispatch({ type: 'task/update', task });
      return { ok: true, task };
    },
    [dispatch, now],
  );

  const toggleTask = useCallback(
    (id: string): Task | null => {
      const existingTask = stateRef.current.tasks.find((task) => task.id === id);
      if (!existingTask) return null;

      const nowIso = now().toISOString();
      const task: Task = {
        ...existingTask,
        completedAt: existingTask.completedAt ? null : nowIso,
        updatedAt: nowIso,
      };

      dispatch({ type: 'task/toggle', id, nowIso });
      return task;
    },
    [dispatch, now],
  );

  const deleteTask = useCallback(
    (id: string): boolean => {
      if (!stateRef.current.tasks.some((task) => task.id === id)) return false;
      dispatch({ type: 'task/delete', id });
      return true;
    },
    [dispatch],
  );

  const completeOnboarding = useCallback(() => {
    dispatch({ type: 'settings/onboarding', completed: true });
  }, [dispatch]);

  const setOnboardingCompleted = useCallback(
    (completed: boolean) => {
      dispatch({ type: 'settings/onboarding', completed });
    },
    [dispatch],
  );

  const setThemeMode = useCallback(
    (themeMode: ThemeMode) => {
      dispatch({ type: 'settings/theme', themeMode });
    },
    [dispatch],
  );

  const deleteCompleted = useCallback((): number => {
    const completedCount = stateRef.current.tasks.filter(
      (task) => task.completedAt !== null,
    ).length;

    if (completedCount > 0) {
      dispatch({ type: 'task/deleteCompleted' });
    }

    return completedCount;
  }, [dispatch]);

  const resetData = useCallback(() => {
    dispatch({
      type: 'app/reset',
      data: createResetMomentumData(now(), stateRef.current.seededAt),
    });
  }, [dispatch, now]);

  const retryPersistence = useCallback(async (): Promise<void> => {
    const currentState = stateRef.current;
    await enqueuePersistence(momentumDataFromState(currentState), currentState.revision);
  }, [enqueuePersistence]);

  const clearPersistenceError = useCallback(() => {
    dispatch({ type: 'persistence/clearError' });
  }, [dispatch]);

  const actions = useMemo<MomentumActions>(
    () => ({
      createTask,
      updateTask,
      toggleTask,
      deleteTask,
      completeOnboarding,
      setOnboardingCompleted,
      setThemeMode,
      deleteCompleted,
      resetData,
      retryLoad: hydrate,
      retryPersistence,
      clearPersistenceError,
    }),
    [
      clearPersistenceError,
      completeOnboarding,
      createTask,
      deleteCompleted,
      deleteTask,
      hydrate,
      resetData,
      retryPersistence,
      setOnboardingCompleted,
      setThemeMode,
      toggleTask,
      updateTask,
    ],
  );

  const value = useMemo<MomentumContextValue>(() => ({ state, actions }), [actions, state]);

  return <MomentumContext.Provider value={value}>{children}</MomentumContext.Provider>;
}

export function useMomentum(): MomentumContextValue {
  const context = useContext(MomentumContext);

  if (!context) {
    throw new Error('useMomentum muss innerhalb eines MomentumProvider verwendet werden.');
  }

  return context;
}

export function useMomentumState(): MomentumState {
  return useMomentum().state;
}

export function useMomentumActions(): MomentumActions {
  return useMomentum().actions;
}
