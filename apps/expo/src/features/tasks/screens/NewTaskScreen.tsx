import { router } from 'expo-router';
import * as Haptics from 'expo-haptics';

import { TaskForm } from '@/features/tasks/components/TaskForm';
import type { TaskDraft } from '@/models';
import { useMomentum } from '@/state';
import { toLocalDateKey } from '@/utils/date';

export function NewTaskScreen() {
  const { state, actions } = useMomentum();
  const initialDraft: TaskDraft = {
    title: '',
    description: null,
    categoryId: state.categories[0]?.id ?? '',
    priority: 'medium',
    date: toLocalDateKey(new Date()),
    time: null,
  };

  return (
    <TaskForm
      initialDraft={initialDraft}
      categories={state.categories}
      submitLabel="Aufgabe erstellen"
      onSubmit={(draft) => {
        const result = actions.createTask(draft);
        if (result.ok) {
          void Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success).catch(
            () => undefined,
          );
          router.back();
        }
      }}
    />
  );
}
