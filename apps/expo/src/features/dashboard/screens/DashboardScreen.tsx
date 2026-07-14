import { useMemo, useState } from 'react';
import { ScrollView, StyleSheet, View, useWindowDimensions } from 'react-native';
import { router } from 'expo-router';
import {
  Button,
  Dialog,
  FAB,
  Icon,
  Portal,
  ProgressBar,
  Surface,
  Text,
  TouchableRipple,
} from 'react-native-paper';
import { SafeAreaView } from 'react-native-safe-area-context';

import { BrandMark } from '@/components/BrandMark';
import { EmptyState } from '@/components/EmptyState';
import { getCategoryColors } from '@/components/CategoryBadge';
import { ScreenContainer } from '@/components/ScreenContainer';
import { SectionHeader } from '@/components/SectionHeader';
import {
  getTaskProgress,
  selectCategoryProgress,
  selectCurrentStreak,
  selectOverdueTasks,
  selectTodayTasks,
} from '@/features/tasks/selectors';
import { TaskCard } from '@/features/tasks/components/TaskCard';
import type { Task } from '@/models';
import { useMomentum } from '@/state';
import { useMomentumTheme } from '@/theme/theme';
import { formatLongDate, getGreeting } from '@/utils/format';

function MetricCard({
  icon,
  value,
  label,
  iconColor,
  iconBackground,
}: {
  icon: string;
  value: string;
  label: string;
  iconColor: string;
  iconBackground: string;
}) {
  const theme = useMomentumTheme();

  return (
    <Surface
      elevation={0}
      style={[
        styles.metricCard,
        { backgroundColor: theme.colors.surface, borderColor: theme.colors.outlineVariant },
      ]}
    >
      <View style={[styles.metricIcon, { backgroundColor: iconBackground }]}>
        <Icon source={icon} size={23} color={iconColor} />
      </View>
      <Text variant="headlineSmall" style={styles.metricValue}>
        {value}
      </Text>
      <Text variant="bodySmall" style={{ color: theme.colors.onSurfaceVariant }}>
        {label}
      </Text>
    </Surface>
  );
}

export function DashboardScreen() {
  const theme = useMomentumTheme();
  const { width } = useWindowDimensions();
  const { state, actions } = useMomentum();
  const [deleteTarget, setDeleteTarget] = useState<Task | null>(null);
  const now = useMemo(() => new Date(), []);

  const todayTasks = useMemo(() => selectTodayTasks(state.tasks, now), [now, state.tasks]);
  const progress = useMemo(() => getTaskProgress(todayTasks), [todayTasks]);
  const categoryProgress = useMemo(
    () => selectCategoryProgress(state.tasks, state.categories, now),
    [now, state.categories, state.tasks],
  );
  const streak = useMemo(() => selectCurrentStreak(state.tasks, now), [now, state.tasks]);
  const overdue = useMemo(() => selectOverdueTasks(state.tasks, now), [now, state.tasks]);
  const categoryById = useMemo(
    () => new Map(state.categories.map((category) => [category.id, category])),
    [state.categories],
  );
  const columnGap = 12;
  const contentWidth = Math.min(width, 760) - (width >= 600 ? 48 : 32);
  const categoryWidth = (contentWidth - columnGap) / 2;

  return (
    <SafeAreaView
      edges={['top']}
      style={[styles.safeArea, { backgroundColor: theme.colors.background }]}
    >
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        <ScreenContainer>
          <View style={styles.header}>
            <View style={styles.headerCopy}>
              <Text variant="bodyLarge" style={{ color: theme.colors.onSurfaceVariant }}>
                {getGreeting(now)}
              </Text>
              <Text variant="headlineMedium" style={styles.screenTitle}>
                Dein Momentum
              </Text>
              <Text variant="bodyMedium" style={{ color: theme.colors.onSurfaceVariant }}>
                {formatLongDate(now)}
              </Text>
            </View>
            <BrandMark compact />
          </View>

          <Surface
            elevation={0}
            style={[styles.progressCard, { backgroundColor: theme.colors.primaryContainer }]}
          >
            <View style={styles.progressTopRow}>
              <View>
                <Text variant="labelLarge" style={{ color: theme.colors.onPrimaryContainer }}>
                  HEUTE
                </Text>
                <Text
                  variant="headlineSmall"
                  style={[styles.progressTitle, { color: theme.colors.onPrimaryContainer }]}
                >
                  {progress.total === 0
                    ? 'Bereit für deinen Tag'
                    : `${progress.completed} von ${progress.total} erledigt`}
                </Text>
              </View>
              <View style={[styles.percentPill, { backgroundColor: theme.colors.surface }]}>
                <Text
                  variant="titleMedium"
                  style={{ color: theme.colors.primary, fontWeight: '800' }}
                >
                  {progress.percentage}%
                </Text>
              </View>
            </View>
            <ProgressBar
              accessibilityLabel={`${progress.percentage} Prozent der heutigen Aufgaben erledigt`}
              progress={progress.percentage / 100}
              color={theme.colors.primary}
              style={[styles.progressBar, { backgroundColor: theme.colors.surfaceVariant }]}
            />
            <Text variant="bodySmall" style={{ color: theme.colors.onPrimaryContainer }}>
              {progress.total === 0
                ? 'Plane deine erste Aufgabe und bring den Tag ins Rollen.'
                : progress.open === 0
                  ? 'Stark – alles für heute ist geschafft.'
                  : `${progress.open} ${progress.open === 1 ? 'Aufgabe wartet' : 'Aufgaben warten'} noch auf dich.`}
            </Text>
          </Surface>

          <View style={styles.metricsRow}>
            <MetricCard
              icon="fire"
              value={`${streak}`}
              label={streak === 1 ? 'Tag in Serie' : 'Tage in Serie'}
              iconColor={theme.momentum.warning}
              iconBackground={theme.momentum.warningContainer}
            />
            <MetricCard
              icon="checkbox-blank-circle-outline"
              value={`${progress.open}`}
              label="heute noch offen"
              iconColor={theme.colors.primary}
              iconBackground={theme.colors.primaryContainer}
            />
          </View>

          {overdue.length > 0 ? (
            <TouchableRipple
              accessibilityRole="button"
              accessibilityLabel={`${overdue.length} überfällige Aufgaben anzeigen`}
              borderless
              onPress={() => router.push({ pathname: '/(tabs)/tasks', params: { status: 'open' } })}
              style={[styles.overdueBanner, { backgroundColor: theme.momentum.warningContainer }]}
            >
              <View style={styles.overdueContent}>
                <Icon source="clock-alert-outline" size={22} color={theme.momentum.warning} />
                <Text
                  variant="bodyMedium"
                  style={[styles.overdueText, { color: theme.momentum.warning }]}
                >
                  {overdue.length} {overdue.length === 1 ? 'Aufgabe ist' : 'Aufgaben sind'}{' '}
                  überfällig
                </Text>
                <Icon source="chevron-right" size={21} color={theme.momentum.warning} />
              </View>
            </TouchableRipple>
          ) : null}

          <View style={styles.sectionBlock}>
            <SectionHeader
              title="Heute"
              subtitle={progress.total > 0 ? `${progress.completed} erledigt` : undefined}
              actionLabel="Alle Aufgaben"
              onAction={() => router.push('/(tabs)/tasks')}
            />
            {todayTasks.length === 0 ? (
              <Surface
                elevation={0}
                style={[styles.emptyCard, { backgroundColor: theme.colors.surface }]}
              >
                <EmptyState
                  compact
                  icon="calendar-plus"
                  title="Noch nichts geplant"
                  message="Lege eine Aufgabe für heute an und starte mit einem klaren nächsten Schritt."
                  actionLabel="Aufgabe planen"
                  onAction={() => router.push('/task/new')}
                />
              </Surface>
            ) : (
              <View style={styles.taskList}>
                {todayTasks.map((task) => {
                  const category = categoryById.get(task.categoryId);
                  return category ? (
                    <TaskCard
                      key={task.id}
                      task={task}
                      category={category}
                      onToggle={actions.toggleTask}
                      onPress={(id) => router.push(`/task/${id}`)}
                      onDelete={setDeleteTarget}
                      showDate={false}
                    />
                  ) : null;
                })}
              </View>
            )}
          </View>

          <View style={styles.sectionBlock}>
            <SectionHeader title="Kategorien" subtitle="Dein heutiger Fokus" />
            <View style={styles.categoryGrid}>
              {categoryProgress.map(({ category, total, completed, percentage }) => {
                const colors = getCategoryColors(category.color, theme.dark);
                return (
                  <TouchableRipple
                    key={category.id}
                    accessibilityRole="button"
                    accessibilityLabel={`${category.name}, ${completed} von ${total} erledigt`}
                    borderless
                    onPress={() =>
                      router.push({ pathname: '/(tabs)/tasks', params: { category: category.id } })
                    }
                    style={[
                      styles.categoryCard,
                      {
                        backgroundColor: theme.colors.surface,
                        borderColor: theme.colors.outlineVariant,
                        width: categoryWidth,
                      },
                    ]}
                  >
                    <View>
                      <View style={[styles.categoryIcon, { backgroundColor: colors.background }]}>
                        <Icon source={category.icon} size={21} color={colors.foreground} />
                      </View>
                      <Text variant="titleSmall" numberOfLines={1} style={styles.categoryName}>
                        {category.name}
                      </Text>
                      <Text variant="labelSmall" style={{ color: theme.colors.onSurfaceVariant }}>
                        {total === 0 ? 'Keine Aufgabe' : `${completed} von ${total} erledigt`}
                      </Text>
                      <ProgressBar
                        progress={percentage / 100}
                        color={colors.foreground}
                        style={[styles.categoryProgress, { backgroundColor: colors.background }]}
                      />
                    </View>
                  </TouchableRipple>
                );
              })}
            </View>
          </View>
        </ScreenContainer>
      </ScrollView>

      <FAB
        icon="plus"
        label="Aufgabe"
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
  categoryCard: {
    borderRadius: 20,
    borderWidth: 1,
    minHeight: 150,
    overflow: 'hidden',
    padding: 16,
  },
  categoryGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 12, marginTop: 8 },
  categoryIcon: {
    alignItems: 'center',
    borderRadius: 14,
    height: 42,
    justifyContent: 'center',
    width: 42,
  },
  categoryName: { fontWeight: '700', marginBottom: 4, marginTop: 15 },
  categoryProgress: { borderRadius: 4, height: 6, marginTop: 14 },
  emptyCard: { borderRadius: 22, marginTop: 8, overflow: 'hidden' },
  fab: { bottom: 18, position: 'absolute', right: 18 },
  header: {
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingBottom: 20,
    paddingTop: 12,
  },
  headerCopy: { flex: 1 },
  metricCard: { borderRadius: 20, borderWidth: 1, flex: 1, minHeight: 142, padding: 16 },
  metricIcon: {
    alignItems: 'center',
    borderRadius: 14,
    height: 42,
    justifyContent: 'center',
    width: 42,
  },
  metricValue: { fontWeight: '800', marginTop: 12 },
  metricsRow: { flexDirection: 'row', gap: 12, marginTop: 12 },
  overdueBanner: { borderRadius: 16, marginTop: 12, overflow: 'hidden' },
  overdueContent: {
    alignItems: 'center',
    flexDirection: 'row',
    minHeight: 54,
    paddingHorizontal: 15,
  },
  overdueText: { flex: 1, fontWeight: '700', marginLeft: 10 },
  percentPill: {
    alignItems: 'center',
    borderRadius: 18,
    justifyContent: 'center',
    minHeight: 48,
    minWidth: 64,
    paddingHorizontal: 10,
  },
  progressBar: { borderRadius: 5, height: 9, marginBottom: 14, marginTop: 22 },
  progressCard: { borderRadius: 26, padding: 20 },
  progressTitle: { fontWeight: '800', letterSpacing: -0.4, marginTop: 4 },
  progressTopRow: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 12,
    justifyContent: 'space-between',
  },
  safeArea: { flex: 1 },
  screenTitle: { fontWeight: '800', letterSpacing: -0.7, marginVertical: 2 },
  scrollContent: { paddingBottom: 112 },
  sectionBlock: { marginTop: 28 },
  taskList: { gap: 10, marginTop: 8 },
});
