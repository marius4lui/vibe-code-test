import { router } from 'expo-router';

import { ErrorState } from '@/components/ErrorState';

export default function NotFoundRoute() {
  return (
    <ErrorState
      title="Seite nicht gefunden"
      message="Dieser Bereich ist nicht mehr verfügbar oder wurde verschoben."
      retryLabel="Zur Startseite"
      onRetry={() => router.replace('/')}
    />
  );
}
