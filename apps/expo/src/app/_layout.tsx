import { useState } from 'react';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { Button, Dialog, Portal, Snackbar, Text } from 'react-native-paper';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import { ErrorState } from '@/components/ErrorState';
import { LoadingScreen } from '@/components/LoadingScreen';
import { MomentumProvider, useMomentum } from '@/state';
import { MomentumThemeProvider } from '@/theme/MomentumThemeProvider';
import { useMomentumTheme } from '@/theme/theme';

export const unstable_settings = {
  anchor: '(tabs)',
};

function AppContent() {
  const { state, actions } = useMomentum();
  const theme = useMomentumTheme();
  const [resetDialogVisible, setResetDialogVisible] = useState(false);

  if (state.status === 'idle' || state.status === 'loading') {
    return <LoadingScreen />;
  }

  if (state.status === 'error') {
    return (
      <>
        <ErrorState
          title="Lokale Daten nicht verfügbar"
          message={state.loadError ?? 'Deine lokalen Daten konnten nicht geladen werden.'}
          onRetry={() => void actions.retryLoad()}
          secondaryLabel="Lokale Daten zurücksetzen"
          onSecondary={() => setResetDialogVisible(true)}
        />
        <Portal>
          <Dialog visible={resetDialogVisible} onDismiss={() => setResetDialogVisible(false)}>
            <Dialog.Icon icon="database-remove-outline" />
            <Dialog.Title>Lokale Daten zurücksetzen?</Dialog.Title>
            <Dialog.Content>
              <Text variant="bodyMedium">
                Alle gespeicherten Aufgaben und Einstellungen werden dauerhaft entfernt.
              </Text>
            </Dialog.Content>
            <Dialog.Actions>
              <Button onPress={() => setResetDialogVisible(false)}>Abbrechen</Button>
              <Button
                textColor={theme.colors.error}
                onPress={() => {
                  setResetDialogVisible(false);
                  actions.resetData();
                }}
              >
                Zurücksetzen
              </Button>
            </Dialog.Actions>
          </Dialog>
        </Portal>
      </>
    );
  }

  return (
    <>
      <Stack
        screenOptions={{
          animation: 'slide_from_right',
          contentStyle: { backgroundColor: theme.colors.background },
          headerShadowVisible: false,
          headerStyle: { backgroundColor: theme.colors.surface },
          headerTintColor: theme.colors.onSurface,
          headerTitleStyle: { fontWeight: '700' },
        }}
      >
        <Stack.Screen name="index" options={{ headerShown: false }} />
        <Stack.Screen name="onboarding" options={{ headerShown: false, animation: 'fade' }} />
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="task/new" options={{ title: 'Neue Aufgabe', presentation: 'modal' }} />
        <Stack.Screen name="task/[id]" options={{ title: 'Aufgabe bearbeiten' }} />
        <Stack.Screen name="+not-found" options={{ title: 'Nicht gefunden' }} />
      </Stack>
      <Snackbar
        visible={state.persistenceError !== null}
        onDismiss={actions.clearPersistenceError}
        duration={7000}
        action={{
          label: 'Erneut',
          onPress: () => void actions.retryPersistence(),
        }}
      >
        {state.persistenceError ?? ''}
      </Snackbar>
      <StatusBar style={theme.dark ? 'light' : 'dark'} />
    </>
  );
}

export default function RootLayout() {
  return (
    <SafeAreaProvider>
      <MomentumProvider>
        <MomentumThemeProvider>
          <AppContent />
        </MomentumThemeProvider>
      </MomentumProvider>
    </SafeAreaProvider>
  );
}
