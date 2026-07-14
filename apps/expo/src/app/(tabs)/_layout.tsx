import { Tabs } from 'expo-router';
import { Icon } from 'react-native-paper';

import { useMomentumTheme } from '@/theme/theme';

export default function TabsLayout() {
  const theme = useMomentumTheme();

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: theme.colors.primary,
        tabBarInactiveTintColor: theme.colors.onSurfaceVariant,
        tabBarStyle: {
          backgroundColor: theme.colors.surface,
          borderTopColor: theme.colors.outlineVariant,
          height: 70,
          paddingBottom: 8,
          paddingTop: 7,
        },
        tabBarLabelStyle: {
          fontSize: 12,
          fontWeight: '700',
        },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: 'Heute',
          tabBarAccessibilityLabel: 'Heute',
          tabBarIcon: ({ color, size, focused }) => (
            <Icon
              source={focused ? 'calendar-today' : 'calendar-blank-outline'}
              size={size}
              color={String(color)}
            />
          ),
        }}
      />
      <Tabs.Screen
        name="tasks"
        options={{
          title: 'Aufgaben',
          tabBarAccessibilityLabel: 'Aufgaben',
          tabBarIcon: ({ color, size, focused }) => (
            <Icon
              source={focused ? 'checkbox-marked-circle' : 'checkbox-marked-circle-outline'}
              size={size}
              color={String(color)}
            />
          ),
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          title: 'Einstellungen',
          tabBarAccessibilityLabel: 'Einstellungen',
          tabBarIcon: ({ color, size, focused }) => (
            <Icon source={focused ? 'cog' : 'cog-outline'} size={size} color={String(color)} />
          ),
        }}
      />
    </Tabs>
  );
}
