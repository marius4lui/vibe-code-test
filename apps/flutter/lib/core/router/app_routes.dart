import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:momentum/features/navigation/presentation/app_tab.dart';
import 'package:momentum/features/navigation/presentation/screens/app_shell_screen.dart';
import 'package:momentum/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:momentum/features/startup/presentation/screens/bootstrap_screen.dart';
import 'package:momentum/features/tasks/presentation/screens/task_editor_screen.dart';

part 'app_routes.g.dart';

@TypedGoRoute<BootstrapRoute>(path: '/')
class BootstrapRoute extends GoRouteData with $BootstrapRoute {
  const BootstrapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BootstrapScreen();
}

@TypedGoRoute<OnboardingRoute>(path: '/welcome')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const OnboardingScreen();
}

@TypedGoRoute<TodayRoute>(path: '/today')
class TodayRoute extends GoRouteData with $TodayRoute {
  const TodayRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppShellScreen(selectedTab: AppTab.today);
  }
}

@TypedGoRoute<TasksRoute>(path: '/tasks')
class TasksRoute extends GoRouteData with $TasksRoute {
  const TasksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppShellScreen(selectedTab: AppTab.tasks);
  }
}

@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppShellScreen(selectedTab: AppTab.settings);
  }
}

@TypedGoRoute<CreateTaskRoute>(path: '/tasks/new')
class CreateTaskRoute extends GoRouteData with $CreateTaskRoute {
  const CreateTaskRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const TaskEditorScreen();
}

@TypedGoRoute<EditTaskRoute>(path: '/tasks/:taskId/edit')
class EditTaskRoute extends GoRouteData with $EditTaskRoute {
  const EditTaskRoute({required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TaskEditorScreen(taskId: taskId);
  }
}
