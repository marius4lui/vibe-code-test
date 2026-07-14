export const TASK_PRIORITIES = ['low', 'medium', 'high'] as const;

export type TaskPriority = (typeof TASK_PRIORITIES)[number];

export interface Task {
  id: string;
  title: string;
  description: string | null;
  categoryId: string;
  priority: TaskPriority;
  /** A local calendar date encoded as YYYY-MM-DD. */
  date: string;
  /** A local time encoded as HH:mm, or null for an unscheduled task. */
  time: string | null;
  completedAt: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface TaskDraft {
  title: string;
  description?: string | null;
  categoryId: string;
  priority: TaskPriority;
  date: string;
  time?: string | null;
}

export type TaskPatch = Partial<TaskDraft>;
