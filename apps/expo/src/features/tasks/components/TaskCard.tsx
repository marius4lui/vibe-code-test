import { useEffect, useState } from 'react';
import {
  AccessibilityInfo,
  Animated,
  Easing,
  LayoutAnimation,
  Pressable,
  StyleSheet,
  View,
} from 'react-native';
import * as Haptics from 'expo-haptics';
import {
  Checkbox,
  Divider,
  Icon,
  IconButton,
  Menu,
  Surface,
  Text,
  TouchableRipple,
} from 'react-native-paper';

import { CategoryBadge } from '@/components/CategoryBadge';
import { PriorityBadge } from '@/features/tasks/components/PriorityBadge';
import type { Category, Task } from '@/models';
import { useMomentumTheme } from '@/theme/theme';
import { formatTaskDate } from '@/utils/format';

type TaskCardProps = {
  task: Task;
  category: Category;
  onToggle: (id: string) => void;
  onPress: (id: string) => void;
  onDelete: (task: Task) => void;
  showDate?: boolean;
};

export function TaskCard({
  task,
  category,
  onToggle,
  onPress,
  onDelete,
  showDate = true,
}: TaskCardProps) {
  const theme = useMomentumTheme();
  const [menuVisible, setMenuVisible] = useState(false);
  const [entrance] = useState(() => new Animated.Value(0));
  const completed = task.completedAt !== null;

  useEffect(() => {
    let active = true;
    void AccessibilityInfo.isReduceMotionEnabled().then((reduceMotion) => {
      if (!active) return;
      Animated.timing(entrance, {
        duration: reduceMotion ? 0 : 200,
        easing: Easing.out(Easing.cubic),
        toValue: 1,
        useNativeDriver: true,
      }).start();
    });

    return () => {
      active = false;
    };
  }, [entrance]);

  const handleToggle = () => {
    LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
    void Haptics.selectionAsync().catch(() => undefined);
    onToggle(task.id);
    AccessibilityInfo.announceForAccessibility(
      completed ? `${task.title} wieder geöffnet` : `${task.title} erledigt`,
    );
  };

  const meta = [showDate ? formatTaskDate(task.date) : null, task.time].filter(Boolean).join(' · ');

  return (
    <Animated.View
      style={{
        opacity: entrance,
        transform: [
          {
            translateY: entrance.interpolate({ inputRange: [0, 1], outputRange: [6, 0] }),
          },
        ],
      }}
    >
      <Surface
        elevation={theme.dark ? 1 : 0}
        style={[
          styles.card,
          {
            backgroundColor: completed ? theme.colors.elevation.level1 : theme.colors.surface,
            borderColor: completed ? theme.colors.outlineVariant : theme.colors.surfaceVariant,
          },
        ]}
      >
        <Pressable
          accessibilityRole="checkbox"
          accessibilityState={{ checked: completed }}
          accessibilityLabel={`${task.title}, ${completed ? 'erledigt, wieder öffnen' : 'als erledigt markieren'}`}
          hitSlop={4}
          onPress={handleToggle}
          style={styles.checkboxHitbox}
        >
          <Checkbox.Android
            status={completed ? 'checked' : 'unchecked'}
            color={theme.momentum.success}
            uncheckedColor={theme.colors.outline}
          />
        </Pressable>

        <TouchableRipple
          accessibilityRole="button"
          accessibilityLabel={`Aufgabe ${task.title} bearbeiten`}
          borderless
          onPress={() => onPress(task.id)}
          style={styles.contentTouch}
        >
          <View style={styles.content}>
            <View style={styles.titleRow}>
              <Text
                variant="titleMedium"
                numberOfLines={2}
                style={[
                  styles.title,
                  completed && {
                    color: theme.colors.onSurfaceVariant,
                    textDecorationLine: 'line-through',
                  },
                ]}
              >
                {task.title}
              </Text>
              <PriorityBadge priority={task.priority} compact />
            </View>

            {task.description ? (
              <Text
                variant="bodySmall"
                numberOfLines={2}
                style={[styles.description, { color: theme.colors.onSurfaceVariant }]}
              >
                {task.description}
              </Text>
            ) : null}

            <View style={styles.metaRow}>
              <CategoryBadge category={category} compact />
              {meta ? (
                <View style={styles.timeRow}>
                  <Icon source={task.time ? 'clock-outline' : 'calendar-blank-outline'} size={14} />
                  <Text
                    variant="labelSmall"
                    numberOfLines={1}
                    style={{ color: theme.colors.onSurfaceVariant }}
                  >
                    {meta}
                  </Text>
                </View>
              ) : null}
            </View>
          </View>
        </TouchableRipple>

        <Menu
          visible={menuVisible}
          onDismiss={() => setMenuVisible(false)}
          anchor={
            <IconButton
              icon="dots-vertical"
              size={21}
              accessibilityLabel={`Weitere Aktionen für ${task.title}`}
              onPress={() => setMenuVisible(true)}
            />
          }
        >
          <Menu.Item
            leadingIcon="pencil-outline"
            title="Bearbeiten"
            onPress={() => {
              setMenuVisible(false);
              onPress(task.id);
            }}
          />
          <Divider />
          <Menu.Item
            leadingIcon="delete-outline"
            title="Löschen"
            titleStyle={{ color: theme.colors.error }}
            onPress={() => {
              setMenuVisible(false);
              onDelete(task);
            }}
          />
        </Menu>
      </Surface>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  card: {
    alignItems: 'flex-start',
    borderRadius: 20,
    borderWidth: 1,
    flexDirection: 'row',
    minHeight: 104,
    overflow: 'hidden',
  },
  checkboxHitbox: {
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 56,
    minWidth: 52,
    paddingTop: 10,
  },
  content: {
    paddingBottom: 14,
    paddingTop: 14,
  },
  contentTouch: {
    flex: 1,
    minHeight: 102,
    paddingRight: 4,
  },
  description: {
    lineHeight: 18,
    marginRight: 8,
    marginTop: 5,
  },
  metaRow: {
    alignItems: 'center',
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 10,
    marginTop: 12,
  },
  timeRow: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 4,
  },
  title: {
    flex: 1,
    fontWeight: '700',
    letterSpacing: -0.15,
  },
  titleRow: {
    alignItems: 'flex-start',
    flexDirection: 'row',
    gap: 8,
  },
});
