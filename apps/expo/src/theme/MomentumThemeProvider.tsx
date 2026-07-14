import { useEffect, useMemo, type PropsWithChildren } from 'react';
import { useColorScheme } from 'react-native';
import * as SystemUI from 'expo-system-ui';
import {
  DarkTheme as NavigationDarkTheme,
  DefaultTheme as NavigationLightTheme,
  ThemeProvider as NavigationThemeProvider,
} from 'expo-router';
import { PaperProvider } from 'react-native-paper';

import { useMomentumState } from '@/state';
import { darkTheme, lightTheme } from '@/theme/theme';

export function MomentumThemeProvider({ children }: PropsWithChildren) {
  const systemScheme = useColorScheme();
  const { settings } = useMomentumState();
  const dark =
    settings.themeMode === 'system' ? systemScheme === 'dark' : settings.themeMode === 'dark';
  const paperTheme = dark ? darkTheme : lightTheme;

  const navigationTheme = useMemo(
    () => ({
      ...(dark ? NavigationDarkTheme : NavigationLightTheme),
      colors: {
        ...(dark ? NavigationDarkTheme.colors : NavigationLightTheme.colors),
        primary: paperTheme.colors.primary,
        background: paperTheme.colors.background,
        card: paperTheme.colors.surface,
        text: paperTheme.colors.onSurface,
        border: paperTheme.colors.outlineVariant,
        notification: paperTheme.colors.error,
      },
    }),
    [dark, paperTheme],
  );

  useEffect(() => {
    void SystemUI.setBackgroundColorAsync(paperTheme.colors.background).catch(() => undefined);
  }, [paperTheme.colors.background]);

  return (
    <PaperProvider theme={paperTheme}>
      <NavigationThemeProvider value={navigationTheme}>{children}</NavigationThemeProvider>
    </PaperProvider>
  );
}
