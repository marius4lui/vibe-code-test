import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/features/dashboard/presentation/screens/today_screen.dart';
import 'package:momentum/features/navigation/presentation/app_tab.dart';
import 'package:momentum/features/settings/presentation/screens/settings_screen.dart';
import 'package:momentum/features/tasks/presentation/screens/tasks_screen.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({required this.selectedTab, super.key});

  final AppTab selectedTab;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final body = switch (selectedTab) {
      AppTab.today => const TodayScreen(),
      AppTab.tasks => const TasksScreen(),
      AppTab.settings => const SettingsScreen(),
    };

    return Scaffold(
      body: body,
      floatingActionButton: selectedTab == AppTab.settings
          ? null
          : FloatingActionButton.extended(
              key: const ValueKey(AppWidgetKeys.taskCreateButton),
              heroTag: AppWidgetKeys.taskCreateButton,
              tooltip: l10n.addTaskTooltip,
              onPressed: () => unawaited(const CreateTaskRoute().push<void>(context)),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addTask),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab.index,
        onDestinationSelected: (index) {
          final destination = AppTab.values.elementAt(index);
          switch (destination) {
            case AppTab.today:
              const TodayRoute().go(context);
            case AppTab.tasks:
              const TasksRoute().go(context);
            case AppTab.settings:
              const SettingsRoute().go(context);
          }
        },
        destinations: [
          NavigationDestination(
            key: const ValueKey(AppWidgetKeys.navigationToday),
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today_rounded),
            label: l10n.navToday,
          ),
          NavigationDestination(
            key: const ValueKey(AppWidgetKeys.navigationTasks),
            icon: const Icon(Icons.checklist_outlined),
            selectedIcon: const Icon(Icons.checklist_rounded),
            label: l10n.navTasks,
          ),
          NavigationDestination(
            key: const ValueKey(AppWidgetKeys.navigationSettings),
            icon: const Icon(Icons.tune_outlined),
            selectedIcon: const Icon(Icons.tune_rounded),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
