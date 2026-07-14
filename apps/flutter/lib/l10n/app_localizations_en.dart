// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Momentum';

  @override
  String get navToday => 'Today';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navSettings => 'Settings';

  @override
  String get loadingTitle => 'Getting things ready';

  @override
  String get loadingBody => 'Your tasks stay on this device.';

  @override
  String get loadingSemantics => 'Momentum is loading';

  @override
  String get startupErrorTitle => 'We couldn\'t load your data';

  @override
  String get startupErrorBody =>
      'Check the local storage and try again. Your existing data has not been changed.';

  @override
  String get retry => 'Try again';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String onboardingPageSemantics(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get onboardingOneTitle => 'Make space for what matters';

  @override
  String get onboardingOneBody => 'Turn your plans into a calm, focused list for each day.';

  @override
  String get onboardingTwoTitle => 'Build momentum, one check at a time';

  @override
  String get onboardingTwoBody =>
      'See progress at a glance and keep your completion streak moving.';

  @override
  String get onboardingThreeTitle => 'Private by design';

  @override
  String get onboardingThreeBody =>
      'Everything is stored locally. No account, cloud, or tracking required.';

  @override
  String get onboardingSaveError => 'Your onboarding choice couldn\'t be saved. Please try again.';

  @override
  String get todayTitle => 'Today';

  @override
  String get dashboardEyebrow => 'YOUR DAY';

  @override
  String get progressTitle => 'Daily progress';

  @override
  String percentValue(int percent) {
    return '$percent%';
  }

  @override
  String completedCount(int completed) {
    String _temp0 = intl.Intl.pluralLogic(
      completed,
      locale: localeName,
      other: '$completed tasks done',
      one: '1 task done',
      zero: 'No tasks done',
    );
    return '$_temp0';
  }

  @override
  String progressSemantics(int completed, int total, int percent) {
    return '$completed of $total tasks complete, $percent percent';
  }

  @override
  String get streakTitle => 'Current streak';

  @override
  String streakDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
      zero: 'Start today',
    );
    return '$_temp0';
  }

  @override
  String get streakBody => 'A day counts when you complete at least one task.';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String categorySummary(int open, int total) {
    return '$open open · $total total';
  }

  @override
  String categoryCardSemantics(String category, String summary) {
    return '$category, $summary';
  }

  @override
  String get todaysTasksTitle => 'Today\'s tasks';

  @override
  String get viewAll => 'View all';

  @override
  String get todayEmptyTitle => 'Your day is open';

  @override
  String get todayEmptyBody => 'Add a task when you\'re ready to give the day some direction.';

  @override
  String get allDoneTitle => 'Everything is checked off';

  @override
  String get allDoneBody => 'Nice work. Take a breath or get a head start on tomorrow.';

  @override
  String get tasksTitle => 'All tasks';

  @override
  String taskCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
      zero: 'No tasks',
    );
    return '$_temp0';
  }

  @override
  String get addTask => 'Add task';

  @override
  String get addTaskTooltip => 'Create a new task';

  @override
  String get createTaskTitle => 'New task';

  @override
  String get editTaskTitle => 'Edit task';

  @override
  String get taskMissingTitle => 'Task not found';

  @override
  String get taskMissingBody =>
      'This task may have been deleted. Return to your task list to continue.';

  @override
  String get searchHint => 'Search title or description';

  @override
  String get searchTooltip => 'Search tasks';

  @override
  String get clearSearchTooltip => 'Clear search';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterPriority => 'Priority';

  @override
  String get filterAll => 'All';

  @override
  String get filterOpen => 'Open';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get allCategories => 'All categories';

  @override
  String get allPriorities => 'All priorities';

  @override
  String get resetFilters => 'Reset filters';

  @override
  String chooseFilterTitle(String filterName) {
    return 'Choose $filterName';
  }

  @override
  String get noTasksTitle => 'No tasks yet';

  @override
  String get noTasksBody => 'Create your first task and start building momentum.';

  @override
  String get noResultsTitle => 'No matching tasks';

  @override
  String get noResultsBody => 'Try a different search or reset your filters.';

  @override
  String get completeTaskTooltip => 'Mark task complete';

  @override
  String get reopenTaskTooltip => 'Reopen task';

  @override
  String get taskMenuTooltip => 'Task actions';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deleteTaskTitle => 'Delete task?';

  @override
  String deleteTaskBody(String title) {
    return '“$title” will be permanently removed from this device.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteConfirm => 'Delete';

  @override
  String taskOpenSemantics(String title) {
    return '$title, open';
  }

  @override
  String taskCompletedSemantics(String title) {
    return '$title, completed';
  }

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryLearning => 'Learning';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get overdue => 'Overdue';

  @override
  String get dueToday => 'Today';

  @override
  String dateAtTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String get taskTitleLabel => 'Title';

  @override
  String get taskTitleHint => 'What do you want to move forward?';

  @override
  String get taskDescriptionLabel => 'Description (optional)';

  @override
  String get taskDescriptionHint => 'Add notes or context';

  @override
  String get categoryLabel => 'Category';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time (optional)';

  @override
  String get chooseDateTooltip => 'Choose due date';

  @override
  String get chooseTimeTooltip => 'Choose due time';

  @override
  String get removeTime => 'Remove time';

  @override
  String get saveTask => 'Save task';

  @override
  String get savingTask => 'Saving…';

  @override
  String get validationTitleRequired => 'Enter a title.';

  @override
  String validationTitleTooLong(int max) {
    return 'Use no more than $max characters.';
  }

  @override
  String validationDescriptionTooLong(int max) {
    return 'Use no more than $max characters.';
  }

  @override
  String get taskSaveError => 'The task couldn\'t be saved. Please try again.';

  @override
  String get taskDeleteError => 'The task couldn\'t be deleted. Please try again.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceBody => 'Choose how Momentum looks on this device.';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get privacyTitle => 'Local & private';

  @override
  String get privacyBody =>
      'Tasks and preferences are stored only on this device. Momentum sends no data to a server.';

  @override
  String get aboutTitle => 'About Momentum';

  @override
  String get versionLabel => 'Version 1.0.0';

  @override
  String get settingsSaveError =>
      'Your setting couldn\'t be saved. The previous choice is still active.';

  @override
  String get closeTooltip => 'Close';

  @override
  String get backTooltip => 'Go back';
}
