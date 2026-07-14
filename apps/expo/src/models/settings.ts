export const THEME_MODES = ['system', 'light', 'dark'] as const;

export type ThemeMode = (typeof THEME_MODES)[number];

export interface MomentumSettings {
  themeMode: ThemeMode;
  onboardingCompleted: boolean;
}

export const DEFAULT_SETTINGS: Readonly<MomentumSettings> = {
  themeMode: 'system',
  onboardingCompleted: false,
};
