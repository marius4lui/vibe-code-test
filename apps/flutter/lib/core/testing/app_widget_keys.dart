/// Stable widget selector names shared by widget and integration tests.
abstract final class AppWidgetKeys {
  static const String onboardingSkipButton = 'onboarding.skip.button';
  static const String onboardingNextButton = 'onboarding.next.button';
  static const String onboardingStartButton = 'onboarding.start.button';

  static const String navigationToday = 'navigation.today';
  static const String navigationTasks = 'navigation.tasks';
  static const String navigationSettings = 'navigation.settings';

  static const String taskCreateButton = 'tasks.create.button';
  static const String taskSaveButton = 'tasks.save.button';
  static const String taskDeleteButton = 'tasks.delete.button';
  static const String taskSearchField = 'tasks.search.field';
  static const String taskStatusFilter = 'tasks.filter.status';
  static const String taskCategoryFilter = 'tasks.filter.category';
  static const String taskPriorityFilter = 'tasks.filter.priority';
  static const String taskResetFilters = 'tasks.filter.reset';
  static const String taskTitleField = 'tasks.form.title';
  static const String taskDescriptionField = 'tasks.form.description';
  static const String taskDateButton = 'tasks.form.date';
  static const String taskTimeButton = 'tasks.form.time';

  static const String settingsThemeMode = 'settings.theme.mode';
  static const String errorRetryButton = 'error.retry.button';
  static const String errorDismissButton = 'error.dismiss.button';

  static String taskCard(String taskId) => 'tasks.card.$taskId';

  static String taskCompletionToggle(String taskId) => 'tasks.completion.$taskId';

  static String taskEditButton(String taskId) => 'tasks.edit.$taskId';
}
