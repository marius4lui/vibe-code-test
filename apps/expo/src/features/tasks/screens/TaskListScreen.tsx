import { useMemo, useState } from 'react';
import { LayoutAnimation, ScrollView, StyleSheet, View } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import {
  Button,
  Chip,
  Dialog,
  FAB,
  Portal,
  Searchbar,
  SegmentedButtons,
  Surface,
  Text,
} from 'react-native-paper';
import { SafeAreaView } from 'react-native-safe-area-context';

import { EmptyState } from '@/components/EmptyState';
import { ScreenContainer } from '@/components/ScreenContainer';
import { TaskCard } from '@/features/tasks/components/TaskCard';
import { selectFilteredTasks, type TaskStatusFilter } from '@/features/tasks/selectors';
import type { Task, TaskPriority } from '@/models';
import { useMomentum } from '@/state';
import { useMomentumTheme } from '@/theme/theme';
import { PRIORITY_LABELS } from '@/utils/format';

function isStatus(value: string | string[] | undefined): value is TaskStatusFilter {
  return value === 'all' || value === 'open' || value === 'completed';
}

function isPriority(value: string | string[] | undefined): value is TaskPriority {
  return value === 'low' || value === 'medium' || value === 'high';
}

export function TaskListScreen() {
  const theme = useMomentumTheme();
  const { state, actions } = useMomentum();
  const params = useLocalSearchParams<{ status?: string; category?: string; priority?: string }>();
  const [query, setQuery] = useState('');
  const [filtersVisible, setFiltersVisible] = useState(Boolean(params.category || params.status));
  const [deleteTarget, setDeleteTarget] = useState<Task | null>(null);
  const status = isStatus(params.status) ? params.status : 'all';
  const categoryId = state.categories.some((category) => category.id === params.category)
    ? (params.category ?? null)
    : null;
  const priority = isPriority(params.priority) ? params.priority : null;

  const setStatus = (value: TaskStatusFilter) =>
    router.setParams({ status: value === 'all' ? '' : value });
  const setCategoryId = (value: string | null) => router.setParams({ category: value ?? '' });
  const setPriority = (value: TaskPriority | null) => router.setParams({ priority: value ?? '' });

  const filteredTasks = useMemo(
    () => selectFilteredTasks(state.tasks, { query, status, categoryId, priority }),
    [categoryId, priority, query, state.tasks, status],
  );
  const categoryById = useMemo(
    () => new Map(state.categories.map((category) => [category.id, category])),
    [state.categories],
  );
  const activeFilterCount =
    Number(status !== 'all') + Number(Boolean(categoryId)) + Number(Boolean(priority));

  const resetFilters = () => {
    router.setParams({ status: '', category: '', priority: '' });
  };

  const toggleFilters = () => {
    LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
    setFiltersVisible((current) => !current);
  };

  const emptyTitle = state.tasks.length === 0 ? 'Noch keine Aufgaben' : 'Keine Treffer';
  const emptyMessage =
    state.tasks.length === 0
      ? 'Erstelle deine erste Aufgabe und mache den nächsten Schritt konkret.'
      : 'Passe deine Suche oder Filter an, um wieder Aufgaben zu sehen.';

  return (
    <SafeAreaView
      edges={['top']}
      style={[styles.safeArea, { backgroundColor: theme.colors.background }]}
    >
      <ScrollView
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        <ScreenContainer>
          <View style={styles.header}>
            <View>
              <Text variant="headlineMedium" style={styles.title}>
                Aufgaben
              </Text>
              <Text variant="bodyMedium" style={{ color: theme.colors.onSurfaceVariant }}>
                {state.tasks.length} {state.tasks.length === 1 ? 'Aufgabe' : 'Aufgaben'} insgesamt
              </Text>
            </View>
          </View>

          <Searchbar
            accessibilityLabel="Aufgaben durchsuchen"
            placeholder="Titel oder Beschreibung suchen"
            value={query}
            onChangeText={setQuery}
            onClearIconPress={() => setQuery('')}
            style={[styles.search, { backgroundColor: theme.colors.surface }]}
            inputStyle={styles.searchInput}
          />

          <View style={styles.filterToolbar}>
            <Button
              accessibilityLabel={
                activeFilterCount > 0 ? `Filter, ${activeFilterCount} aktiv` : 'Aufgaben filtern'
              }
              icon={filtersVisible ? 'tune-variant' : 'tune'}
              mode={activeFilterCount > 0 ? 'contained-tonal' : 'outlined'}
              onPress={toggleFilters}
            >
              Filter{activeFilterCount > 0 ? ` · ${activeFilterCount}` : ''}
            </Button>
            {(activeFilterCount > 0 || query) && (
              <Button
                compact
                onPress={() => {
                  resetFilters();
                  setQuery('');
                }}
              >
                Zurücksetzen
              </Button>
            )}
          </View>

          {filtersVisible ? (
            <Surface
              elevation={0}
              style={[
                styles.filterPanel,
                { backgroundColor: theme.colors.surface, borderColor: theme.colors.outlineVariant },
              ]}
            >
              <Text variant="titleSmall" style={styles.filterLabel}>
                Status
              </Text>
              <SegmentedButtons
                value={status}
                onValueChange={(value) => setStatus(value as TaskStatusFilter)}
                buttons={[
                  { value: 'all', label: 'Alle' },
                  { value: 'open', label: 'Offen', icon: 'circle-outline' },
                  { value: 'completed', label: 'Erledigt', icon: 'check-circle-outline' },
                ]}
                density="small"
              />

              <Text variant="titleSmall" style={styles.filterLabel}>
                Kategorie
              </Text>
              <View style={styles.chipRow} accessibilityRole="radiogroup">
                <Chip
                  accessibilityRole="radio"
                  accessibilityState={{ selected: categoryId === null }}
                  selected={categoryId === null}
                  onPress={() => setCategoryId(null)}
                  style={styles.filterChip}
                >
                  Alle
                </Chip>
                {state.categories.map((category) => (
                  <Chip
                    key={category.id}
                    accessibilityRole="radio"
                    accessibilityState={{ selected: categoryId === category.id }}
                    icon={category.icon}
                    selected={categoryId === category.id}
                    onPress={() => setCategoryId(category.id)}
                    style={styles.filterChip}
                  >
                    {category.name}
                  </Chip>
                ))}
              </View>

              <Text variant="titleSmall" style={styles.filterLabel}>
                Priorität
              </Text>
              <View style={styles.chipRow} accessibilityRole="radiogroup">
                <Chip
                  accessibilityRole="radio"
                  accessibilityState={{ selected: priority === null }}
                  selected={priority === null}
                  onPress={() => setPriority(null)}
                  style={styles.filterChip}
                >
                  Alle
                </Chip>
                {(['low', 'medium', 'high'] as const).map((value) => (
                  <Chip
                    key={value}
                    accessibilityRole="radio"
                    accessibilityState={{ selected: priority === value }}
                    selected={priority === value}
                    onPress={() => setPriority(value)}
                    style={styles.filterChip}
                  >
                    {PRIORITY_LABELS[value]}
                  </Chip>
                ))}
              </View>
            </Surface>
          ) : null}

          <View style={styles.resultHeader}>
            <Text variant="titleMedium" style={styles.resultTitle}>
              {filteredTasks.length} {filteredTasks.length === 1 ? 'Ergebnis' : 'Ergebnisse'}
            </Text>
          </View>

          {filteredTasks.length === 0 ? (
            <EmptyState
              compact
              icon={state.tasks.length === 0 ? 'clipboard-text-outline' : 'magnify-close'}
              title={emptyTitle}
              message={emptyMessage}
              actionLabel={state.tasks.length === 0 ? 'Aufgabe erstellen' : 'Filter zurücksetzen'}
              onAction={
                state.tasks.length === 0
                  ? () => router.push('/task/new')
                  : () => {
                      resetFilters();
                      setQuery('');
                    }
              }
            />
          ) : (
            <View style={styles.list}>
              {filteredTasks.map((task) => {
                const category = categoryById.get(task.categoryId);
                return category ? (
                  <TaskCard
                    key={task.id}
                    task={task}
                    category={category}
                    onToggle={actions.toggleTask}
                    onPress={(id) => router.push(`/task/${id}`)}
                    onDelete={setDeleteTarget}
                  />
                ) : null;
              })}
            </View>
          )}
        </ScreenContainer>
      </ScrollView>

      <FAB
        icon="plus"
        accessibilityLabel="Neue Aufgabe erstellen"
        onPress={() => router.push('/task/new')}
        style={[styles.fab, { backgroundColor: theme.colors.primaryContainer }]}
      />

      <Portal>
        <Dialog visible={deleteTarget !== null} onDismiss={() => setDeleteTarget(null)}>
          <Dialog.Icon icon="delete-outline" />
          <Dialog.Title>Aufgabe löschen?</Dialog.Title>
          <Dialog.Content>
            <Text variant="bodyMedium">
              „{deleteTarget?.title}“ wird dauerhaft von diesem Gerät entfernt.
            </Text>
          </Dialog.Content>
          <Dialog.Actions>
            <Button onPress={() => setDeleteTarget(null)}>Abbrechen</Button>
            <Button
              textColor={theme.colors.error}
              onPress={() => {
                if (deleteTarget) actions.deleteTask(deleteTarget.id);
                setDeleteTarget(null);
              }}
            >
              Löschen
            </Button>
          </Dialog.Actions>
        </Dialog>
      </Portal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  chipRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  fab: { bottom: 18, position: 'absolute', right: 18 },
  filterChip: { minHeight: 40 },
  filterLabel: { fontWeight: '700', marginBottom: 10, marginTop: 18 },
  filterPanel: { borderRadius: 20, borderWidth: 1, marginTop: 14, padding: 16 },
  filterToolbar: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 8,
    justifyContent: 'space-between',
    marginTop: 12,
  },
  header: { paddingBottom: 18, paddingTop: 12 },
  list: { gap: 10 },
  resultHeader: { marginBottom: 10, marginTop: 24 },
  resultTitle: { fontWeight: '700' },
  safeArea: { flex: 1 },
  scrollContent: { paddingBottom: 112 },
  search: { borderRadius: 18, elevation: 0 },
  searchInput: { minHeight: 48 },
  title: { fontWeight: '800', letterSpacing: -0.7 },
});
