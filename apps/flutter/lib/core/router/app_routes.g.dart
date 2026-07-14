// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $bootstrapRoute,
  $onboardingRoute,
  $todayRoute,
  $tasksRoute,
  $settingsRoute,
  $createTaskRoute,
  $editTaskRoute,
];

RouteBase get $bootstrapRoute => GoRouteData.$route(path: '/', factory: $BootstrapRoute._fromState);

mixin $BootstrapRoute on GoRouteData {
  static BootstrapRoute _fromState(GoRouterState state) => const BootstrapRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingRoute =>
    GoRouteData.$route(path: '/welcome', factory: $OnboardingRoute._fromState);

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) => const OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/welcome');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $todayRoute => GoRouteData.$route(path: '/today', factory: $TodayRoute._fromState);

mixin $TodayRoute on GoRouteData {
  static TodayRoute _fromState(GoRouterState state) => const TodayRoute();

  @override
  String get location => GoRouteData.$location('/today');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $tasksRoute => GoRouteData.$route(path: '/tasks', factory: $TasksRoute._fromState);

mixin $TasksRoute on GoRouteData {
  static TasksRoute _fromState(GoRouterState state) => const TasksRoute();

  @override
  String get location => GoRouteData.$location('/tasks');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsRoute =>
    GoRouteData.$route(path: '/settings', factory: $SettingsRoute._fromState);

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $createTaskRoute =>
    GoRouteData.$route(path: '/tasks/new', factory: $CreateTaskRoute._fromState);

mixin $CreateTaskRoute on GoRouteData {
  static CreateTaskRoute _fromState(GoRouterState state) => const CreateTaskRoute();

  @override
  String get location => GoRouteData.$location('/tasks/new');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editTaskRoute =>
    GoRouteData.$route(path: '/tasks/:taskId/edit', factory: $EditTaskRoute._fromState);

mixin $EditTaskRoute on GoRouteData {
  static EditTaskRoute _fromState(GoRouterState state) =>
      EditTaskRoute(taskId: state.pathParameters['taskId']!);

  EditTaskRoute get _self => this as EditTaskRoute;

  @override
  String get location => GoRouteData.$location('/tasks/${Uri.encodeComponent(_self.taskId)}/edit');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
