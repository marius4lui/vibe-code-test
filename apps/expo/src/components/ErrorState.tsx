import { StyleSheet, View } from 'react-native';
import { Button, Icon, Text } from 'react-native-paper';

import { useMomentumTheme } from '@/theme/theme';

type ErrorStateProps = {
  title?: string;
  message: string;
  onRetry?: () => void;
  retryLabel?: string;
  secondaryLabel?: string;
  onSecondary?: () => void;
};

export function ErrorState({
  title = 'Das hat nicht geklappt',
  message,
  onRetry,
  retryLabel = 'Erneut versuchen',
  secondaryLabel,
  onSecondary,
}: ErrorStateProps) {
  const theme = useMomentumTheme();

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <View style={[styles.icon, { backgroundColor: theme.colors.errorContainer }]}>
        <Icon source="alert-circle-outline" size={32} color={theme.colors.error} />
      </View>
      <Text variant="titleLarge" style={styles.title}>
        {title}
      </Text>
      <Text variant="bodyMedium" style={[styles.message, { color: theme.colors.onSurfaceVariant }]}>
        {message}
      </Text>
      <View style={styles.actions}>
        {onRetry ? (
          <Button mode="contained" icon="refresh" onPress={onRetry}>
            {retryLabel}
          </Button>
        ) : null}
        {secondaryLabel && onSecondary ? (
          <Button mode="text" onPress={onSecondary}>
            {secondaryLabel}
          </Button>
        ) : null}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  actions: {
    gap: 8,
    marginTop: 20,
  },
  container: {
    alignItems: 'center',
    flex: 1,
    justifyContent: 'center',
    padding: 28,
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
    marginTop: 10,
    maxWidth: 380,
    textAlign: 'center',
  },
  title: {
    fontWeight: '700',
    marginTop: 20,
    textAlign: 'center',
  },
});
