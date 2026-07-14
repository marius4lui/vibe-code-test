import type { Category } from './category';
import type { MomentumSettings } from './settings';
import type { Task } from './task';

export const MOMENTUM_SCHEMA_VERSION = 1;

export interface MomentumData {
  tasks: Task[];
  categories: Category[];
  settings: MomentumSettings;
  didSeed: boolean;
  seededAt: string | null;
}

export interface PersistedMomentumState {
  version: typeof MOMENTUM_SCHEMA_VERSION;
  data: MomentumData;
}
