import { StyleSheet, View } from 'react-native';
import { Icon, Text } from 'react-native-paper';

import { useMomentumTheme } from '@/theme/theme';

type BrandMarkProps = {
  compact?: boolean;
  inverted?: boolean;
};

export function BrandMark({ compact = false, inverted = false }: BrandMarkProps) {
  const theme = useMomentumTheme();
  const iconColor = inverted ? theme.colors.onPrimary : theme.colors.primary;
  const backgroundColor = inverted ? theme.colors.primary : theme.colors.primaryContainer;

  return (
    <View style={styles.row} accessibilityLabel="Momentum">
      <View style={[styles.mark, compact && styles.markCompact, { backgroundColor }]}>
        <Icon source="trending-up" size={compact ? 22 : 30} color={iconColor} />
      </View>
      {!compact ? (
        <Text variant="headlineSmall" style={[styles.wordmark, { color: theme.colors.onSurface }]}>
          Momentum
        </Text>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 12,
  },
  mark: {
    alignItems: 'center',
    borderRadius: 18,
    height: 56,
    justifyContent: 'center',
    width: 56,
  },
  markCompact: {
    borderRadius: 14,
    height: 44,
    width: 44,
  },
  wordmark: {
    fontWeight: '700',
    letterSpacing: -0.5,
  },
});
