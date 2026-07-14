import type { PropsWithChildren } from 'react';
import { Stack } from 'expo-router';
import { renderRouter, screen } from 'expo-router/testing-library';
import { userEvent, waitFor } from '@testing-library/react-native';
import { PaperProvider } from 'react-native-paper';

import { createResetMomentumData } from '@/data';
import { NewTaskScreen } from '@/features/tasks/screens/NewTaskScreen';
import { TaskListScreen } from '@/features/tasks/screens/TaskListScreen';
import { MomentumProvider } from '@/state';
import { deserializeMomentumData, MOMENTUM_STORAGE_KEY, serializeMomentumData } from '@/storage';
import { lightTheme } from '@/theme/theme';

import { InMemoryStorage } from './helpers/in-memory-storage';

jest.mock('@react-native-community/datetimepicker', () => ({
  __esModule: true,
  default: () => null,
}));

jest.mock('expo-haptics', () => ({
  NotificationFeedbackType: { Success: 'success' },
  notificationAsync: jest.fn().mockResolvedValue(undefined),
  selectionAsync: jest.fn().mockResolvedValue(undefined),
}));

const NOW_ISO = '2026-07-14T10:00:00.000Z';
const TASK_ID = 'integration-task';
const TASK_TITLE = 'Projektstatus zusammenfassen';

const TestLayout = () => <Stack screenOptions={{ headerShown: false }} />;

describe('central task flow', () => {
  it('creates a task, returns to the list, and completes it', async () => {
    jest.useFakeTimers();
    jest.setSystemTime(new Date(NOW_ISO));

    const initialData = {
      ...createResetMomentumData(new Date(NOW_ISO)),
      settings: {
        themeMode: 'light' as const,
        onboardingCompleted: true,
      },
    };
    const storage = new InMemoryStorage({
      [MOMENTUM_STORAGE_KEY]: serializeMomentumData(initialData),
    });

    function TestProviders({ children }: PropsWithChildren) {
      return (
        <MomentumProvider storage={storage} now={() => new Date(NOW_ISO)} idFactory={() => TASK_ID}>
          <PaperProvider theme={lightTheme}>{children}</PaperProvider>
        </MomentumProvider>
      );
    }

    const routerResult = renderRouter(
      {
        _layout: TestLayout,
        '(tabs)/tasks': TaskListScreen,
        'task/new': NewTaskScreen,
      },
      {
        initialUrl: '/tasks',
        wrapper: TestProviders,
      },
    );

    const user = userEvent.setup({
      advanceTimers: (delay) => jest.advanceTimersByTime(delay),
    });

    await user.press(await screen.findByRole('button', { name: 'Neue Aufgabe erstellen' }));
    expect(routerResult.getPathname()).toBe('/task/new');

    await user.type(screen.getByLabelText('Titel'), TASK_TITLE);
    await user.press(screen.getByRole('button', { name: 'Aufgabe erstellen' }));

    await waitFor(() => expect(routerResult.getPathname()).toBe('/tasks'));

    const openTask = await screen.findByRole('checkbox', {
      name: `${TASK_TITLE}, als erledigt markieren`,
    });
    expect(openTask).not.toBeChecked();

    await user.press(openTask);

    await waitFor(() => {
      expect(
        screen.getByRole('checkbox', {
          name: `${TASK_TITLE}, erledigt, wieder öffnen`,
        }),
      ).toBeChecked();
    });

    await waitFor(() => {
      const serialized = storage.peek(MOMENTUM_STORAGE_KEY);
      expect(serialized).not.toBeNull();

      const persistedTask = deserializeMomentumData(serialized!).tasks.find(
        (task) => task.id === TASK_ID,
      );
      expect(persistedTask).toMatchObject({
        title: TASK_TITLE,
        completedAt: NOW_ISO,
      });
    });
  });
});
