import { StyleSheet, View } from 'react-native';
import { Button, Icon, Text } from 'react-native-paper';

import { useMomentumTheme } from '@/theme/theme';

type EmptyStateProps = {
  icon: string;
  title: string;
  message: string;
  actionLabel?: string;
  onAction?: () => void;
  compact?: boolean;
};

export function EmptyState({
  icon,
  title,
  message,
  actionLabel,
  onAction,
  compact = false,
}: EmptyStateProps) {
  const theme = useMomentumTheme();

  return (
    <View style={[styles.container, compact && styles.compact]}>
      <View style={[styles.icon, { backgroundColor: theme.colors.secondaryContainer }]}>
        <Icon source={icon} size={30} color={theme.colors.onSecondaryContainer} />
      </View>
      <Text variant="titleMedium" style={styles.title}>
        {title}
      </Text>
      <Text variant="bodyMedium" style={[styles.message, { color: theme.colors.onSurfaceVariant }]}>
        {message}
      </Text>
      {actionLabel && onAction ? (
        <Button mode="contained-tonal" onPress={onAction} style={styles.action}>
          {actionLabel}
        </Button>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  action: {
    marginTop: 12,
  },
  compact: {
    minHeight: 220,
    paddingVertical: 24,
  },
  container: {
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 320,
    paddingHorizontal: 28,
    paddingVertical: 44,
  },
  icon: {
    alignItems: 'center',
    borderRadius: 22,
    height: 64,
    justifyContent: 'center',
    width: 64,
  },
  message: {
    lineHeight: 21,
    marginTop: 8,
    maxWidth: 320,
    textAlign: 'center',
  },
  title: {
    fontWeight: '700',
    marginTop: 20,
    textAlign: 'center',
  },
});
