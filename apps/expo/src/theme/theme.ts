import {
  MD3DarkTheme,
  MD3LightTheme,
  type MD3Theme,
  configureFonts,
  useTheme,
} from 'react-native-paper';

export type MomentumTheme = MD3Theme & {
  momentum: {
    success: string;
    successContainer: string;
    warning: string;
    warningContainer: string;
    highPriority: string;
    mediumPriority: string;
    lowPriority: string;
    cardShadow: string;
  };
};

const fonts = configureFonts({ config: MD3LightTheme.fonts });

export const lightTheme: MomentumTheme = {
  ...MD3LightTheme,
  roundness: 5,
  fonts,
  colors: {
    ...MD3LightTheme.colors,
    primary: '#4059C7',
    onPrimary: '#FFFFFF',
    primaryContainer: '#E0E5FF',
    onPrimaryContainer: '#16256B',
    secondary: '#426274',
    onSecondary: '#FFFFFF',
    secondaryContainer: '#C6E7FA',
    onSecondaryContainer: '#183747',
    tertiary: '#6A5D16',
    tertiaryContainer: '#F3E48E',
    background: '#F8F7FC',
    onBackground: '#1B1B1F',
    surface: '#FFFFFF',
    surfaceVariant: '#E3E1EA',
    surfaceDisabled: 'rgba(27, 27, 31, 0.12)',
    onSurface: '#1B1B1F',
    onSurfaceVariant: '#46464F',
    outline: '#777680',
    outlineVariant: '#C7C5D0',
    error: '#BA1A1A',
    errorContainer: '#FFDAD6',
    elevation: {
      ...MD3LightTheme.colors.elevation,
      level0: 'transparent',
      level1: '#F2F1F8',
      level2: '#ECECF6',
      level3: '#E7E7F3',
      level4: '#E5E5F1',
      level5: '#E1E2EF',
    },
  },
  momentum: {
    success: '#147A4A',
    successContainer: '#C7F2D9',
    warning: '#8A5100',
    warningContainer: '#FFE0B2',
    highPriority: '#B3261E',
    mediumPriority: '#9A5B00',
    lowPriority: '#3E5F90',
    cardShadow: '#17171A',
  },
};

export const darkTheme: MomentumTheme = {
  ...MD3DarkTheme,
  roundness: 5,
  fonts,
  colors: {
    ...MD3DarkTheme.colors,
    primary: '#BAC3FF',
    onPrimary: '#0E2678',
    primaryContainer: '#293F9B',
    onPrimaryContainer: '#DEE2FF',
    secondary: '#AACBDE',
    onSecondary: '#113343',
    secondaryContainer: '#294B5B',
    onSecondaryContainer: '#C6E7FA',
    tertiary: '#D7C873',
    tertiaryContainer: '#504600',
    background: '#111318',
    onBackground: '#E4E1E8',
    surface: '#191B21',
    surfaceVariant: '#46464F',
    surfaceDisabled: 'rgba(228, 225, 232, 0.12)',
    onSurface: '#E4E1E8',
    onSurfaceVariant: '#C7C5D0',
    outline: '#91909A',
    outlineVariant: '#46464F',
    error: '#FFB4AB',
    errorContainer: '#93000A',
    elevation: {
      ...MD3DarkTheme.colors.elevation,
      level0: 'transparent',
      level1: '#1D2028',
      level2: '#22242E',
      level3: '#262935',
      level4: '#282B38',
      level5: '#2B2E3C',
    },
  },
  momentum: {
    success: '#72DFA5',
    successContainer: '#0B4F2E',
    warning: '#FFB95C',
    warningContainer: '#603D00',
    highPriority: '#FFB4AB',
    mediumPriority: '#FFB95C',
    lowPriority: '#ADC7F8',
    cardShadow: '#000000',
  },
};

export function useMomentumTheme(): MomentumTheme {
  return useTheme<MomentumTheme>();
}
