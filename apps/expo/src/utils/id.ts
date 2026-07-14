export type IdFactory = () => string;

export const createId: IdFactory = () => {
  const timestamp = Date.now().toString(36);
  const random = Math.random().toString(36).slice(2, 10);
  return `task_${timestamp}_${random}`;
};
