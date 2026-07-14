import type { Category, Task, TaskPriority } from '@/models';
import {
  addDaysToLocalDateKey,
  compareLocalDateKeys,
  localDateKeyFromIso,
  toLocalDateKey,
} from '@/utils/date';

export type TaskStatusFilter = 'all' | 'open' | 'completed';

export interface TaskFilters {
  query?: string;
  status?: TaskStatusFilter;
  categoryId?: string | null;
  priority?: TaskPriority | null;
}

export interface TaskProgress {
  total: number;
  completed: number;
  open: number;
  percentage: number;
}

export interface CategoryProgress extends TaskProgress {
  category: Category;
}

const PRIORITY_ORDER: Readonly<Record<TaskPriority, number>> = {
  high: 0,
  medium: 1,
  low: 2,
};

export function compareTasks(left: Task, right: Task): number {
  if (Boolean(left.completedAt) !== Boolean(right.completedAt)) {
    return left.completedAt ? 1 : -1;
  }

  const dateComparison = compareLocalDateKeys(left.date, right.date);
  if (dateComparison !== 0) {
    return dateComparison;
  }

  if (left.time !== right.time) {
    if (left.time === null) return 1;
    if (right.time === null) return -1;
    return left.time.localeCompare(right.time);
  }

  const priorityComparison = PRIORITY_ORDER[left.priority] - PRIORITY_ORDER[right.priority];
  if (priorityComparison !== 0) {
    return priorityComparison;
  }

  return left.createdAt.localeCompare(right.createdAt);
}

export function sortTasks(tasks: readonly Task[]): Task[] {
  return [...tasks].sort(compareTasks);
}

export function selectTaskById(tasks: readonly Task[], id: string): Task | undefined {
  return tasks.find((task) => task.id === id);
}

export function selectTasksForDate(tasks: readonly Task[], date: string): Task[] {
  return sortTasks(tasks.filter((task) => task.date === date));
}

export function selectTodayTasks(tasks: readonly Task[], now: Date = new Date()): Task[] {
  return selectTasksForDate(tasks, toLocalDateKey(now));
}

export function getTaskProgress(tasks: readonly Task[]): TaskProgress {
  const total = tasks.length;
  const completed = tasks.filter((task) => task.completedAt !== null).length;

  return {
    total,
    completed,
    open: total - completed,
    percentage: total === 0 ? 0 : Math.round((completed / total) * 100),
  };
}

export function selectTodayProgress(tasks: readonly Task[], now: Date = new Date()): TaskProgress {
  return getTaskProgress(selectTodayTasks(tasks, now));
}

export function selectCategoryProgress(
  tasks: readonly Task[],
  categories: readonly Category[],
  now: Date = new Date(),
): CategoryProgress[] {
  const todayTasks = selectTodayTasks(tasks, now);

  return categories.map((category) => ({
    category,
    ...getTaskProgress(todayTasks.filter((task) => task.categoryId === category.id)),
  }));
}

export function selectOverdueTasks(tasks: readonly Task[], now: Date = new Date()): Task[] {
  const today = toLocalDateKey(now);
  return sortTasks(tasks.filter((task) => task.completedAt === null && task.date < today));
}

export function selectCurrentStreak(tasks: readonly Task[], now: Date = new Date()): number {
  const completedDays = new Set<string>();

  for (const task of tasks) {
    if (!task.completedAt) continue;
    const completionDay = localDateKeyFromIso(task.completedAt);
    if (completionDay) completedDays.add(completionDay);
  }

  const today = toLocalDateKey(now);
  let cursor = completedDays.has(today) ? today : addDaysToLocalDateKey(today, -1);
  let streak = 0;

  while (completedDays.has(cursor)) {
    streak += 1;
    cursor = addDaysToLocalDateKey(cursor, -1);
  }

  return streak;
}

export function selectFilteredTasks(tasks: readonly Task[], filters: TaskFilters = {}): Task[] {
  const query = filters.query?.trim().toLocaleLowerCase() ?? '';
  const status = filters.status ?? 'all';

  const filtered = tasks.filter((task) => {
    if (status === 'open' && task.completedAt !== null) return false;
    if (status === 'completed' && task.completedAt === null) return false;
    if (filters.categoryId && task.categoryId !== filters.categoryId) return false;
    if (filters.priority && task.priority !== filters.priority) return false;

    if (query) {
      const searchableText = `${task.title} ${task.description ?? ''}`.toLocaleLowerCase();
      if (!searchableText.includes(query)) return false;
    }

    return true;
  });

  return sortTasks(filtered);
}
