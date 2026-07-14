import { StyleSheet, View } from 'react-native';
import { Button, Text } from 'react-native-paper';

type SectionHeaderProps = {
  title: string;
  subtitle?: string;
  actionLabel?: string;
  onAction?: () => void;
};

export function SectionHeader({ title, subtitle, actionLabel, onAction }: SectionHeaderProps) {
  return (
    <View style={styles.container}>
      <View style={styles.textColumn}>
        <Text variant="titleLarge" style={styles.title}>
          {title}
        </Text>
        {subtitle ? (
          <Text variant="bodySmall" style={styles.subtitle}>
            {subtitle}
          </Text>
        ) : null}
      </View>
      {actionLabel && onAction ? (
        <Button compact onPress={onAction} accessibilityLabel={`${title}: ${actionLabel}`}>
          {actionLabel}
        </Button>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'space-between',
    minHeight: 48,
  },
  subtitle: {
    marginTop: 2,
    opacity: 0.7,
  },
  textColumn: {
    flex: 1,
  },
  title: {
    fontWeight: '700',
    letterSpacing: -0.3,
  },
});
