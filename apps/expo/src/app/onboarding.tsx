import { useRef, useState } from 'react';
import {
  FlatList,
  NativeScrollEvent,
  NativeSyntheticEvent,
  ScrollView,
  StyleSheet,
  View,
  useWindowDimensions,
} from 'react-native';
import { router } from 'expo-router';
import * as Haptics from 'expo-haptics';
import { Button, Icon, Surface, Text } from 'react-native-paper';
import { SafeAreaView } from 'react-native-safe-area-context';

import { BrandMark } from '@/components/BrandMark';
import { useMomentumActions } from '@/state';
import { useMomentumTheme } from '@/theme/theme';

type OnboardingSlide = {
  id: string;
  eyebrow: string;
  title: string;
  description: string;
  icon: string;
};

const SLIDES: readonly OnboardingSlide[] = [
  {
    id: 'clarity',
    eyebrow: 'DEIN TAG, AUF EINEN BLICK',
    title: 'Mehr Klarheit. Weniger Kopfchaos.',
    description:
      'Sammle Aufgaben an einem ruhigen Ort und konzentriere dich auf das, was heute wirklich zählt.',
    icon: 'view-dashboard-outline',
  },
  {
    id: 'progress',
    eyebrow: 'KLEINE SCHRITTE, SICHTBAR',
    title: 'Fortschritt, der dich weiterträgt.',
    description:
      'Erledige Aufgaben, behalte deinen Tagesfortschritt im Blick und baue eine beständige Serie auf.',
    icon: 'chart-donut',
  },
  {
    id: 'private',
    eyebrow: 'IN DEINEM RHYTHMUS',
    title: 'Persönlich. Lokal. Ganz bei dir.',
    description:
      'Deine Daten bleiben auf diesem Gerät. Hell oder dunkel – Momentum passt sich deinem Alltag an.',
    icon: 'shield-lock-outline',
  },
];

function SlideVisual({ index }: { index: number }) {
  const theme = useMomentumTheme();

  if (index === 0) {
    return (
      <View style={styles.visualStack}>
        {[
          ['check-circle', 'Tagesplanung', theme.momentum.success],
          ['circle-outline', '30 Minuten bewegen', theme.colors.primary],
          ['circle-outline', 'Notizen ordnen', theme.colors.tertiary],
        ].map(([icon, label, color], itemIndex) => (
          <Surface
            key={label}
            elevation={itemIndex === 0 ? 2 : 1}
            style={[
              styles.miniTask,
              {
                backgroundColor: theme.colors.surface,
                marginLeft: itemIndex * 10,
                marginRight: (2 - itemIndex) * 10,
              },
            ]}
          >
            <Icon source={icon} size={22} color={color} />
            <Text variant="titleSmall" style={styles.miniTaskText}>
              {label}
            </Text>
          </Surface>
        ))}
      </View>
    );
  }

  if (index === 1) {
    return (
      <View style={styles.progressVisual}>
        <View
          style={[
            styles.progressCircle,
            { borderColor: theme.colors.primary, backgroundColor: theme.colors.primaryContainer },
          ]}
        >
          <Text
            variant="headlineMedium"
            style={{ color: theme.colors.onPrimaryContainer, fontWeight: '800' }}
          >
            75%
          </Text>
          <Text variant="labelMedium" style={{ color: theme.colors.onPrimaryContainer }}>
            heute
          </Text>
        </View>
        <Surface
          elevation={2}
          style={[styles.streakPill, { backgroundColor: theme.colors.surface }]}
        >
          <Icon source="fire" size={24} color={theme.momentum.warning} />
          <View>
            <Text variant="titleMedium" style={styles.bold}>
              4 Tage
            </Text>
            <Text variant="labelSmall" style={{ color: theme.colors.onSurfaceVariant }}>
              Deine aktuelle Serie
            </Text>
          </View>
        </Surface>
      </View>
    );
  }

  return (
    <View style={styles.privacyVisual}>
      <View style={[styles.shield, { backgroundColor: theme.colors.primaryContainer }]}>
        <Icon source="shield-check" size={56} color={theme.colors.primary} />
      </View>
      <View style={styles.privacyChips}>
        <Surface
          elevation={1}
          style={[styles.privacyChip, { backgroundColor: theme.colors.surface }]}
        >
          <Icon source="cellphone-lock" size={18} color={theme.momentum.success} />
          <Text variant="labelLarge">Nur auf deinem Gerät</Text>
        </Surface>
        <Surface
          elevation={1}
          style={[styles.privacyChip, { backgroundColor: theme.colors.surface }]}
        >
          <Icon source="theme-light-dark" size={18} color={theme.colors.primary} />
          <Text variant="labelLarge">Hell & Dunkel</Text>
        </Surface>
      </View>
    </View>
  );
}

export default function OnboardingRoute() {
  const theme = useMomentumTheme();
  const { height, width } = useWindowDimensions();
  const actions = useMomentumActions();
  const listRef = useRef<FlatList<OnboardingSlide>>(null);
  const [page, setPage] = useState(0);

  const finish = () => {
    void Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success).catch(() => undefined);
    actions.completeOnboarding();
    router.replace('/(tabs)');
  };

  const goTo = (nextPage: number) => {
    listRef.current?.scrollToIndex({ index: nextPage, animated: true });
    setPage(nextPage);
  };

  const handleScrollEnd = (event: NativeSyntheticEvent<NativeScrollEvent>) => {
    setPage(Math.round(event.nativeEvent.contentOffset.x / width));
  };

  return (
    <SafeAreaView style={[styles.safeArea, { backgroundColor: theme.colors.background }]}>
      <View style={styles.topBar}>
        <BrandMark compact />
        {page < SLIDES.length - 1 ? (
          <Button accessibilityLabel="Onboarding überspringen" onPress={finish} compact>
            Überspringen
          </Button>
        ) : (
          <View style={styles.skipPlaceholder} />
        )}
      </View>

      <FlatList
        ref={listRef}
        data={SLIDES}
        horizontal
        pagingEnabled
        bounces={false}
        keyExtractor={(item) => item.id}
        onMomentumScrollEnd={handleScrollEnd}
        showsHorizontalScrollIndicator={false}
        getItemLayout={(_, index) => ({ length: width, offset: width * index, index })}
        renderItem={({ item, index }) => (
          <View style={[styles.slide, { width }]}>
            <ScrollView
              showsVerticalScrollIndicator={false}
              contentContainerStyle={[
                styles.slideInner,
                { gap: height < 700 ? 20 : 30, paddingVertical: height < 700 ? 8 : 12 },
              ]}
            >
              <View
                style={[
                  styles.visualCard,
                  {
                    backgroundColor: theme.colors.elevation.level1,
                    height: height < 700 ? 210 : 260,
                  },
                ]}
              >
                <View
                  style={[styles.visualIcon, { backgroundColor: theme.colors.primaryContainer }]}
                >
                  <Icon source={item.icon} size={26} color={theme.colors.primary} />
                </View>
                <SlideVisual index={index} />
              </View>

              <View style={styles.copy}>
                <Text
                  variant="labelLarge"
                  style={[styles.eyebrow, { color: theme.colors.primary }]}
                >
                  {item.eyebrow}
                </Text>
                <Text variant="headlineLarge" style={styles.heading}>
                  {item.title}
                </Text>
                <Text
                  variant="bodyLarge"
                  style={[styles.description, { color: theme.colors.onSurfaceVariant }]}
                >
                  {item.description}
                </Text>
              </View>
            </ScrollView>
          </View>
        )}
      />

      <View style={styles.bottomArea}>
        <View style={styles.dots} accessibilityLabel={`Seite ${page + 1} von ${SLIDES.length}`}>
          {SLIDES.map((slide, index) => (
            <View
              key={slide.id}
              style={[
                styles.dot,
                {
                  backgroundColor:
                    index === page ? theme.colors.primary : theme.colors.outlineVariant,
                  width: index === page ? 24 : 8,
                },
              ]}
            />
          ))}
        </View>
        <View style={styles.navigationRow}>
          {page > 0 ? (
            <Button mode="text" icon="arrow-left" onPress={() => goTo(page - 1)}>
              Zurück
            </Button>
          ) : (
            <View style={styles.backPlaceholder} />
          )}
          <Button
            mode="contained"
            contentStyle={styles.nextContent}
            icon={page === SLIDES.length - 1 ? 'check' : 'arrow-right'}
            onPress={page === SLIDES.length - 1 ? finish : () => goTo(page + 1)}
          >
            {page === SLIDES.length - 1 ? 'Loslegen' : 'Weiter'}
          </Button>
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  backPlaceholder: { width: 88 },
  bold: { fontWeight: '800' },
  bottomArea: { gap: 18, paddingBottom: 12, paddingHorizontal: 20 },
  copy: { alignItems: 'center', maxWidth: 560 },
  description: { lineHeight: 26, marginTop: 16, maxWidth: 520, textAlign: 'center' },
  dot: { borderRadius: 5, height: 8 },
  dots: { alignItems: 'center', flexDirection: 'row', gap: 8, justifyContent: 'center' },
  eyebrow: { fontWeight: '800', letterSpacing: 1.1, textAlign: 'center' },
  heading: { fontWeight: '800', letterSpacing: -0.9, marginTop: 12, textAlign: 'center' },
  miniTask: {
    alignItems: 'center',
    borderRadius: 16,
    flexDirection: 'row',
    gap: 12,
    minHeight: 54,
    paddingHorizontal: 16,
  },
  miniTaskText: { flex: 1, fontWeight: '700' },
  navigationRow: { alignItems: 'center', flexDirection: 'row', justifyContent: 'space-between' },
  nextContent: { minHeight: 48, paddingHorizontal: 14 },
  privacyChip: {
    alignItems: 'center',
    borderRadius: 16,
    flexDirection: 'row',
    gap: 8,
    paddingHorizontal: 14,
    paddingVertical: 11,
  },
  privacyChips: { gap: 10 },
  privacyVisual: { alignItems: 'center', gap: 20 },
  progressCircle: {
    alignItems: 'center',
    borderRadius: 62,
    borderWidth: 9,
    height: 124,
    justifyContent: 'center',
    width: 124,
  },
  progressVisual: { alignItems: 'center', gap: 18 },
  safeArea: { flex: 1 },
  shield: {
    alignItems: 'center',
    borderRadius: 40,
    height: 112,
    justifyContent: 'center',
    width: 112,
  },
  skipPlaceholder: { height: 44, width: 96 },
  slide: { flex: 1 },
  slideInner: {
    alignItems: 'center',
    flexGrow: 1,
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  streakPill: {
    alignItems: 'center',
    borderRadius: 20,
    flexDirection: 'row',
    gap: 12,
    paddingHorizontal: 18,
    paddingVertical: 12,
  },
  topBar: {
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    paddingTop: 8,
  },
  visualCard: {
    borderRadius: 32,
    justifyContent: 'center',
    maxWidth: 460,
    overflow: 'hidden',
    padding: 28,
    width: '100%',
  },
  visualIcon: {
    alignItems: 'center',
    borderRadius: 18,
    height: 52,
    justifyContent: 'center',
    left: 18,
    position: 'absolute',
    top: 18,
    width: 52,
  },
  visualStack: { gap: 10, marginTop: 24 },
});
