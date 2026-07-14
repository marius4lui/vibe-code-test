import { useState } from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import Constants from 'expo-constants';
import { router } from 'expo-router';
import {
  Button,
  Dialog,
  Icon,
  List,
  Portal,
  SegmentedButtons,
  Surface,
  Text,
} from 'react-native-paper';
import { SafeAreaView } from 'react-native-safe-area-context';

import { BrandMark } from '@/components/BrandMark';
import { ScreenContainer } from '@/components/ScreenContainer';
import type { ThemeMode } from '@/models';
import { useMomentum } from '@/state';
import { useMomentumTheme } from '@/theme/theme';

type Confirmation = 'completed' | 'reset' | null;

export function SettingsScreen() {
  const theme = useMomentumTheme();
  const { state, actions } = useMomentum();
  const [confirmation, setConfirmation] = useState<Confirmation>(null);
  const completedCount = state.tasks.filter((task) => task.completedAt !== null).length;
  const version = Constants.expoConfig?.version ?? '1.0.0';

  const openOnboarding = () => {
    actions.setOnboardingCompleted(false);
    router.replace('/onboarding');
  };

  const confirmAction = () => {
    if (confirmation === 'completed') {
      actions.deleteCompleted();
    } else if (confirmation === 'reset') {
      actions.resetData();
      router.replace('/onboarding');
    }
    setConfirmation(null);
  };

  return (
    <SafeAreaView
      edges={['top']}
      style={[styles.safeArea, { backgroundColor: theme.colors.background }]}
    >
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        <ScreenContainer>
          <View style={styles.header}>
            <View>
              <Text variant="headlineMedium" style={styles.title}>
                Einstellungen
              </Text>
              <Text variant="bodyMedium" style={{ color: theme.colors.onSurfaceVariant }}>
                Momentum nach deinem Rhythmus
              </Text>
            </View>
            <BrandMark compact />
          </View>

          <Text variant="titleSmall" style={[styles.sectionLabel, { color: theme.colors.primary }]}>
            DARSTELLUNG
          </Text>
          <Surface
            elevation={0}
            style={[
              styles.card,
              { backgroundColor: theme.colors.surface, borderColor: theme.colors.outlineVariant },
            ]}
          >
            <View style={styles.cardHeading}>
              <View style={[styles.iconBox, { backgroundColor: theme.colors.primaryContainer }]}>
                <Icon source="theme-light-dark" size={22} color={theme.colors.primary} />
              </View>
              <View style={styles.headingCopy}>
                <Text variant="titleMedium" style={styles.cardTitle}>
                  Erscheinungsbild
                </Text>
                <Text variant="bodySmall" style={{ color: theme.colors.onSurfaceVariant }}>
                  Wird sofort auf die gesamte App angewendet.
                </Text>
              </View>
            </View>
            <SegmentedButtons
              value={state.settings.themeMode}
              onValueChange={(value) => actions.setThemeMode(value as ThemeMode)}
              buttons={[
                { value: 'system', label: 'System', icon: 'cellphone-cog' },
                { value: 'light', label: 'Hell', icon: 'white-balance-sunny' },
                { value: 'dark', label: 'Dunkel', icon: 'weather-night' },
              ]}
              style={styles.themeButtons}
            />
          </Surface>

          <Text variant="titleSmall" style={[styles.sectionLabel, { color: theme.colors.primary }]}>
            DEINE DATEN
          </Text>
          <Surface
            elevation={0}
            style={[
              styles.card,
              styles.listCard,
              { backgroundColor: theme.colors.surface, borderColor: theme.colors.outlineVariant },
            ]}
          >
            <List.Item
              title="Lokaler Speicher"
              description={
                state.persistenceStatus === 'saving'
                  ? 'Änderungen werden gespeichert …'
                  : `${state.tasks.length} Aufgaben · nur auf diesem Gerät`
              }
              left={(props) => <List.Icon {...props} icon="database-lock-outline" />}
              right={() => (
                <Icon
                  source={state.persistenceStatus === 'saving' ? 'sync' : 'check-circle-outline'}
                  size={22}
                  color={
                    state.persistenceStatus === 'saving'
                      ? theme.colors.primary
                      : theme.momentum.success
                  }
                />
              )}
              style={styles.listItem}
            />
            <View style={[styles.divider, { backgroundColor: theme.colors.outlineVariant }]} />
            <List.Item
              title="Erledigte Aufgaben löschen"
              description={
                completedCount === 0
                  ? 'Keine erledigten Aufgaben vorhanden'
                  : `${completedCount} ${completedCount === 1 ? 'Aufgabe' : 'Aufgaben'} dauerhaft entfernen`
              }
              left={(props) => <List.Icon {...props} icon="archive-remove-outline" />}
              right={(props) => <List.Icon {...props} icon="chevron-right" />}
              disabled={completedCount === 0}
              onPress={() => setConfirmation('completed')}
              style={styles.listItem}
            />
            <View style={[styles.divider, { backgroundColor: theme.colors.outlineVariant }]} />
            <List.Item
              title="Alle App-Daten zurücksetzen"
              description="Aufgaben und Einstellungen entfernen"
              titleStyle={{ color: theme.colors.error }}
              left={(props) => (
                <List.Icon {...props} color={theme.colors.error} icon="delete-alert-outline" />
              )}
              right={(props) => <List.Icon {...props} icon="chevron-right" />}
              onPress={() => setConfirmation('reset')}
              style={styles.listItem}
            />
          </Surface>

          <Text variant="titleSmall" style={[styles.sectionLabel, { color: theme.colors.primary }]}>
            HILFE & INFO
          </Text>
          <Surface
            elevation={0}
            style={[
              styles.card,
              styles.listCard,
              { backgroundColor: theme.colors.surface, borderColor: theme.colors.outlineVariant },
            ]}
          >
            <List.Item
              title="Einführung erneut ansehen"
              description="Die drei Momentum-Grundlagen"
              left={(props) => <List.Icon {...props} icon="play-circle-outline" />}
              right={(props) => <List.Icon {...props} icon="chevron-right" />}
              onPress={openOnboarding}
              style={styles.listItem}
            />
            <View style={[styles.divider, { backgroundColor: theme.colors.outlineVariant }]} />
            <List.Item
              title="Datenschutz"
              description="Kein Konto, kein Tracking, keine Cloud"
              left={(props) => <List.Icon {...props} icon="shield-lock-outline" />}
              style={styles.listItem}
            />
          </Surface>

          <View style={styles.about}>
            <BrandMark />
            <Text variant="bodySmall" style={{ color: theme.colors.onSurfaceVariant }}>
              Version {version} · Lokal entwickelt für deinen Fokus
            </Text>
          </View>
        </ScreenContainer>
      </ScrollView>

      <Portal>
        <Dialog visible={confirmation !== null} onDismiss={() => setConfirmation(null)}>
          <Dialog.Icon
            icon={confirmation === 'reset' ? 'delete-alert-outline' : 'archive-remove-outline'}
          />
          <Dialog.Title>
            {confirmation === 'reset' ? 'Alle App-Daten löschen?' : 'Erledigte Aufgaben löschen?'}
          </Dialog.Title>
          <Dialog.Content>
            <Text variant="bodyMedium">
              {confirmation === 'reset'
                ? 'Alle Aufgaben und Einstellungen werden dauerhaft entfernt. Momentum startet danach ohne Beispieldaten neu.'
                : `${completedCount} ${completedCount === 1 ? 'erledigte Aufgabe wird' : 'erledigte Aufgaben werden'} dauerhaft entfernt.`}
            </Text>
          </Dialog.Content>
          <Dialog.Actions>
            <Button onPress={() => setConfirmation(null)}>Abbrechen</Button>
            <Button textColor={theme.colors.error} onPress={confirmAction}>
              Löschen
            </Button>
          </Dialog.Actions>
        </Dialog>
      </Portal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  about: { alignItems: 'center', gap: 14, paddingBottom: 18, paddingTop: 34 },
  card: { borderRadius: 22, borderWidth: 1, overflow: 'hidden', padding: 16 },
  cardHeading: { alignItems: 'center', flexDirection: 'row', gap: 14 },
  cardTitle: { fontWeight: '700' },
  divider: { height: StyleSheet.hairlineWidth, marginHorizontal: 16 },
  header: {
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingBottom: 10,
    paddingTop: 12,
  },
  headingCopy: { flex: 1, gap: 3 },
  iconBox: {
    alignItems: 'center',
    borderRadius: 15,
    height: 46,
    justifyContent: 'center',
    width: 46,
  },
  listCard: { padding: 0 },
  listItem: { minHeight: 72, paddingHorizontal: 12 },
  safeArea: { flex: 1 },
  scrollContent: { paddingBottom: 30 },
  sectionLabel: { fontWeight: '800', letterSpacing: 1, marginBottom: 10, marginTop: 28 },
  themeButtons: { marginTop: 20 },
  title: { fontWeight: '800', letterSpacing: -0.7 },
});
