export type CategoryColor = 'indigo' | 'cyan' | 'green' | 'amber';

export interface Category {
  id: string;
  name: string;
  icon: string;
  color: CategoryColor;
}
