import type { PropsWithChildren } from 'react';
import { StyleSheet, View, useWindowDimensions } from 'react-native';

type ScreenContainerProps = PropsWithChildren<{
  padded?: boolean;
  testID?: string;
}>;

export function ScreenContainer({ children, padded = true, testID }: ScreenContainerProps) {
  const { width } = useWindowDimensions();
  const horizontalPadding = width >= 600 ? 24 : 16;

  return (
    <View
      testID={testID}
      style={[styles.container, padded && { paddingHorizontal: horizontalPadding }]}
    >
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignSelf: 'center',
    maxWidth: 760,
    width: '100%',
  },
});
