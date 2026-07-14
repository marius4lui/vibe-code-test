import { useEffect, useState } from 'react';
import { Animated, Easing, StyleSheet, View } from 'react-native';
import { ActivityIndicator, Text } from 'react-native-paper';

import { BrandMark } from '@/components/BrandMark';
import { useMomentumTheme } from '@/theme/theme';

export function LoadingScreen() {
  const theme = useMomentumTheme();
  const [opacity] = useState(() => new Animated.Value(0));

  useEffect(() => {
    Animated.timing(opacity, {
      duration: 280,
      easing: Easing.out(Easing.cubic),
      toValue: 1,
      useNativeDriver: true,
    }).start();
  }, [opacity]);

  return (
    <Animated.View
      accessibilityLabel="Momentum wird geladen"
      accessibilityRole="progressbar"
      style={[styles.container, { backgroundColor: theme.colors.background, opacity }]}
    >
      <BrandMark />
      <View style={styles.loadingRow}>
        <ActivityIndicator size={20} />
        <Text variant="bodyMedium" style={{ color: theme.colors.onSurfaceVariant }}>
          Dein Tag wird vorbereitet …
        </Text>
      </View>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    flex: 1,
    justifyContent: 'center',
    padding: 24,
  },
  loadingRow: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 12,
    marginTop: 28,
  },
});
