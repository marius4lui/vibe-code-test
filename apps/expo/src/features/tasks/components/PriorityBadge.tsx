import { StyleSheet, View } from 'react-native';
import { Icon, Text } from 'react-native-paper';

import type { TaskPriority } from '@/models';
import { useMomentumTheme } from '@/theme/theme';
import { PRIORITY_LABELS } from '@/utils/format';

type PriorityBadgeProps = {
  priority: TaskPriority;
  compact?: boolean;
};

const ICONS: Record<TaskPriority, string> = {
  high: 'chevron-double-up',
  medium: 'equal',
  low: 'chevron-down',
};

export function PriorityBadge({ priority, compact = false }: PriorityBadgeProps) {
  const theme = useMomentumTheme();
  const color =
    priority === 'high'
      ? theme.momentum.highPriority
      : priority === 'medium'
        ? theme.momentum.mediumPriority
        : theme.momentum.lowPriority;

  return (
    <View style={styles.container} accessibilityLabel={`Priorität ${PRIORITY_LABELS[priority]}`}>
      <Icon source={ICONS[priority]} size={compact ? 14 : 16} color={color} />
      {!compact ? (
        <Text variant="labelSmall" style={[styles.label, { color }]}>
          {PRIORITY_LABELS[priority]}
        </Text>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 3,
  },
  label: {
    fontWeight: '700',
  },
});
