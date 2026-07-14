import { useState } from 'react';
import { router, useLocalSearchParams } from 'expo-router';
import * as Haptics from 'expo-haptics';
import { Button, Dialog, Portal, Text } from 'react-native-paper';

import { ErrorState } from '@/components/ErrorState';
import { TaskForm } from '@/features/tasks/components/TaskForm';
import type { TaskDraft } from '@/models';
import { useMomentum } from '@/state';
import { useMomentumTheme } from '@/theme/theme';

export function EditTaskScreen() {
  const theme = useMomentumTheme();
  const params = useLocalSearchParams<{ id?: string | string[] }>();
  const id = Array.isArray(params.id) ? params.id[0] : params.id;
  const { state, actions } = useMomentum();
  const [deleteDialogVisible, setDeleteDialogVisible] = useState(false);
  const task = state.tasks.find((candidate) => candidate.id === id);

  if (!task) {
    return (
      <ErrorState
        title="Aufgabe nicht gefunden"
        message="Die Aufgabe wurde möglicherweise bereits gelöscht."
        retryLabel="Zurück zu den Aufgaben"
        onRetry={() => router.back()}
      />
    );
  }

  const initialDraft: TaskDraft = {
    title: task.title,
    description: task.description,
    categoryId: task.categoryId,
    priority: task.priority,
    date: task.date,
    time: task.time,
  };

  return (
    <>
      <TaskForm
        key={task.id}
        initialDraft={initialDraft}
        categories={state.categories}
        submitLabel="Änderungen speichern"
        onDelete={() => setDeleteDialogVisible(true)}
        onSubmit={(draft) => {
          const result = actions.updateTask(task.id, draft);
          if (result.ok) {
            void Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success).catch(
              () => undefined,
            );
            router.back();
          }
        }}
      />

      <Portal>
        <Dialog visible={deleteDialogVisible} onDismiss={() => setDeleteDialogVisible(false)}>
          <Dialog.Icon icon="delete-outline" />
          <Dialog.Title>Aufgabe löschen?</Dialog.Title>
          <Dialog.Content>
            <Text variant="bodyMedium">
              „{task.title}“ wird dauerhaft von diesem Gerät entfernt.
            </Text>
          </Dialog.Content>
          <Dialog.Actions>
            <Button onPress={() => setDeleteDialogVisible(false)}>Abbrechen</Button>
            <Button
              textColor={theme.colors.error}
              onPress={() => {
                actions.deleteTask(task.id);
                setDeleteDialogVisible(false);
                router.back();
              }}
            >
              Löschen
            </Button>
          </Dialog.Actions>
        </Dialog>
      </Portal>
    </>
  );
}
