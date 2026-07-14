import type { StorageAdapter } from '@/storage';

export class InMemoryStorage implements StorageAdapter {
  private readonly values: Map<string, string>;

  constructor(initialValues: Readonly<Record<string, string>> = {}) {
    this.values = new Map(Object.entries(initialValues));
  }

  async getItem(key: string): Promise<string | null> {
    return this.values.get(key) ?? null;
  }

  async setItem(key: string, value: string): Promise<void> {
    this.values.set(key, value);
  }

  async removeItem(key: string): Promise<void> {
    this.values.delete(key);
  }

  peek(key: string): string | null {
    return this.values.get(key) ?? null;
  }
}
