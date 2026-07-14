import { StyleSheet, View } from 'react-native';
import { Icon, Text } from 'react-native-paper';

import type { Category, CategoryColor } from '@/models';
import { useMomentumTheme } from '@/theme/theme';

const LIGHT_COLORS: Record<CategoryColor, { foreground: string; background: string }> = {
  indigo: { foreground: '#3349A8', background: '#E2E6FF' },
  cyan: { foreground: '#006874', background: '#C7F0F6' },
  green: { foreground: '#126B43', background: '#C9EED8' },
  amber: { foreground: '#755A00', background: '#F8E7A4' },
};

const DARK_COLORS: Record<CategoryColor, { foreground: string; background: string }> = {
  indigo: { foreground: '#C0C8FF', background: '#293B87' },
  cyan: { foreground: '#8AD4DF', background: '#124A52' },
  green: { foreground: '#8CDBAE', background: '#164D34' },
  amber: { foreground: '#E6CA70', background: '#514400' },
};

export function getCategoryColors(color: CategoryColor, dark: boolean) {
  return (dark ? DARK_COLORS : LIGHT_COLORS)[color];
}

type CategoryBadgeProps = {
  category: Category;
  compact?: boolean;
};

export function CategoryBadge({ category, compact = false }: CategoryBadgeProps) {
  const theme = useMomentumTheme();
  const colors = getCategoryColors(category.color, theme.dark);

  return (
    <View
      style={[styles.container, compact && styles.compact, { backgroundColor: colors.background }]}
      accessibilityLabel={`Kategorie ${category.name}`}
    >
      <Icon source={category.icon} size={compact ? 14 : 16} color={colors.foreground} />
      <Text
        variant="labelMedium"
        numberOfLines={1}
        style={[styles.label, { color: colors.foreground }]}
      >
        {category.name}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  compact: {
    paddingHorizontal: 8,
    paddingVertical: 4,
  },
  container: {
    alignItems: 'center',
    alignSelf: 'flex-start',
    borderRadius: 12,
    flexDirection: 'row',
    gap: 5,
    maxWidth: 150,
    paddingHorizontal: 10,
    paddingVertical: 6,
  },
  label: {
    fontWeight: '700',
  },
});
