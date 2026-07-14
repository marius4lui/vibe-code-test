import { Redirect } from 'expo-router';

import { useMomentumState } from '@/state';

export default function EntryRoute() {
  const { settings } = useMomentumState();
  return <Redirect href={settings.onboardingCompleted ? '/(tabs)' : '/onboarding'} />;
}
