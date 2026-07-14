import type { Category } from '@/models';

export const CATEGORY_IDS = {
  work: 'work',
  personal: 'personal',
  health: 'health',
  learning: 'learning',
} as const;

const DEFAULT_CATEGORY_VALUES: readonly Category[] = [
  {
    id: CATEGORY_IDS.work,
    name: 'Arbeit',
    icon: 'briefcase-outline',
    color: 'indigo',
  },
  {
    id: CATEGORY_IDS.personal,
    name: 'Persönlich',
    icon: 'account-outline',
    color: 'cyan',
  },
  {
    id: CATEGORY_IDS.health,
    name: 'Gesundheit',
    icon: 'heart-pulse',
    color: 'green',
  },
  {
    id: CATEGORY_IDS.learning,
    name: 'Lernen',
    icon: 'school-outline',
    color: 'amber',
  },
];

export function createDefaultCategories(): Category[] {
  return DEFAULT_CATEGORY_VALUES.map((category) => ({ ...category }));
}
