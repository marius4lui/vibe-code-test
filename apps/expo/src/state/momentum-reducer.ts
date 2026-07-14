import { createDefaultCategories } from '@/data';
import { DEFAULT_SETTINGS, type MomentumData, type Task, type ThemeMode } from '@/models';

export type MomentumLoadStatus = 'idle' | 'loading' | 'ready' | 'error';
export type MomentumPersistenceStatus = 'idle' | 'saving' | 'error';

export interface MomentumState extends MomentumData {
  status: MomentumLoadStatus;
  loadError: string | null;
  persistenceStatus: MomentumPersistenceStatus;
  persistenceError: string | null;
  /** Incremented only when persistent domain data changes. */
  revision: number;
  persistedRevision: number;
}

export type MomentumReducerAction =
  | { type: 'app/hydrateStart' }
  | { type: 'app/hydrateSuccess'; data: MomentumData }
  | { type: 'app/hydrateError'; message: string }
  | { type: 'app/reset'; data: MomentumData }
  | { type: 'persistence/start'; revision: number }
  | { type: 'persistence/success'; revision: number }
  | { type: 'persistence/error'; revision: number; message: string }
  | { type: 'persistence/clearError' }
  | { type: 'task/create'; task: Task }
  | { type: 'task/update'; task: Task }
  | { type: 'task/toggle'; id: string; nowIso: string }
  | { type: 'task/delete'; id: string }
  | { type: 'task/deleteCompleted' }
  | { type: 'settings/onboarding'; completed: boolean }
  | { type: 'settings/theme'; themeMode: ThemeMode };

export function createInitialMomentumState(): MomentumState {
  return {
    tasks: [],
    categories: createDefaultCategories(),
    settings: { ...DEFAULT_SETTINGS },
    didSeed: false,
    seededAt: null,
    status: 'idle',
    loadError: null,
    persistenceStatus: 'idle',
    persistenceError: null,
    revision: 0,
    persistedRevision: 0,
  };
}

function withDomainChange(
  state: MomentumState,
  change: Partial<
    Pick<MomentumState, 'tasks' | 'categories' | 'settings' | 'didSeed' | 'seededAt'>
  >,
): MomentumState {
  return {
    ...state,
    ...change,
    revision: state.revision + 1,
  };
}

export function momentumReducer(
  state: MomentumState,
  action: MomentumReducerAction,
): MomentumState {
  switch (action.type) {
    case 'app/hydrateStart':
      return {
        ...state,
        status: 'loading',
        loadError: null,
      };

    case 'app/hydrateSuccess':
      return {
        ...action.data,
        status: 'ready',
        loadError: null,
        persistenceStatus: 'idle',
        persistenceError: null,
        revision: 1,
        persistedRevision: 0,
      };

    case 'app/hydrateError':
      return {
        ...state,
        status: 'error',
        loadError: action.message,
        persistenceStatus: 'idle',
      };

    case 'app/reset':
      return {
        ...state,
        ...action.data,
        status: 'ready',
        loadError: null,
        persistenceError: null,
        revision: state.revision + 1,
      };

    case 'persistence/start':
      return {
        ...state,
        persistenceStatus: 'saving',
      };

    case 'persistence/success': {
      const persistedRevision = Math.max(state.persistedRevision, action.revision);
      return {
        ...state,
        persistedRevision,
        persistenceStatus: persistedRevision >= state.revision ? 'idle' : 'saving',
        persistenceError: null,
      };
    }

    case 'persistence/error':
      return {
        ...state,
        persistenceStatus: 'error',
        persistenceError: action.message,
      };

    case 'persistence/clearError':
      return {
        ...state,
        persistenceStatus: 'idle',
        persistenceError: null,
      };

    case 'task/create':
      return withDomainChange(state, {
        tasks: [...state.tasks, action.task],
      });

    case 'task/update': {
      const taskIndex = state.tasks.findIndex((task) => task.id === action.task.id);
      if (taskIndex < 0) return state;

      const tasks = [...state.tasks];
      tasks[taskIndex] = action.task;
      return withDomainChange(state, { tasks });
    }

    case 'task/toggle': {
      const taskIndex = state.tasks.findIndex((task) => task.id === action.id);
      if (taskIndex < 0) return state;

      const task = state.tasks[taskIndex];
      const tasks = [...state.tasks];
      tasks[taskIndex] = {
        ...task,
        completedAt: task.completedAt ? null : action.nowIso,
        updatedAt: action.nowIso,
      };
      return withDomainChange(state, { tasks });
    }

    case 'task/delete': {
      const tasks = state.tasks.filter((task) => task.id !== action.id);
      return tasks.length === state.tasks.length ? state : withDomainChange(state, { tasks });
    }

    case 'task/deleteCompleted': {
      const tasks = state.tasks.filter((task) => task.completedAt === null);
      return tasks.length === state.tasks.length ? state : withDomainChange(state, { tasks });
    }

    case 'settings/onboarding':
      if (state.settings.onboardingCompleted === action.completed) return state;
      return withDomainChange(state, {
        settings: {
          ...state.settings,
          onboardingCompleted: action.completed,
        },
      });

    case 'settings/theme':
      if (state.settings.themeMode === action.themeMode) return state;
      return withDomainChange(state, {
        settings: {
          ...state.settings,
          themeMode: action.themeMode,
        },
      });

    default:
      return state;
  }
}

export function momentumDataFromState(state: MomentumState): MomentumData {
  return {
    tasks: state.tasks,
    categories: state.categories,
    settings: state.settings,
    didSeed: state.didSeed,
    seededAt: state.seededAt,
  };
}
