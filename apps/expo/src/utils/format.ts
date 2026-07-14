import type { TaskPriority } from '@/models';
import { addDaysToLocalDateKey, parseLocalDate, toLocalDateKey } from '@/utils/date';

const longDateFormatter = new Intl.DateTimeFormat('de-DE', {
  weekday: 'long',
  day: '2-digit',
  month: 'long',
});

const shortDateFormatter = new Intl.DateTimeFormat('de-DE', {
  day: '2-digit',
  month: 'short',
});

export const PRIORITY_LABELS: Readonly<Record<TaskPriority, string>> = {
  low: 'Niedrig',
  medium: 'Mittel',
  high: 'Hoch',
};

export function formatLongDate(date: Date): string {
  const formatted = longDateFormatter.format(date);
  return formatted.charAt(0).toUpperCase() + formatted.slice(1);
}

export function formatTaskDate(dateKey: string, now: Date = new Date()): string {
  const today = toLocalDateKey(now);
  if (dateKey === today) return 'Heute';
  if (dateKey === addDaysToLocalDateKey(today, 1)) return 'Morgen';
  if (dateKey === addDaysToLocalDateKey(today, -1)) return 'Gestern';

  const parsed = parseLocalDate(dateKey);
  return parsed ? shortDateFormatter.format(parsed) : dateKey;
}

export function formatDateInput(dateKey: string): string {
  const parsed = parseLocalDate(dateKey);
  if (!parsed) return dateKey;
  return new Intl.DateTimeFormat('de-DE', {
    weekday: 'short',
    day: '2-digit',
    month: 'long',
    year: 'numeric',
  }).format(parsed);
}

export function getGreeting(date: Date = new Date()): string {
  const hours = date.getHours();
  if (hours < 11) return 'Guten Morgen';
  if (hours < 17) return 'Guten Tag';
  return 'Guten Abend';
}
