import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('de'), Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Momentum'**
  String get appName;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @loadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting things ready'**
  String get loadingTitle;

  /// No description provided for @loadingBody.
  ///
  /// In en, this message translates to:
  /// **'Your tasks stay on this device.'**
  String get loadingBody;

  /// No description provided for @loadingSemantics.
  ///
  /// In en, this message translates to:
  /// **'Momentum is loading'**
  String get loadingSemantics;

  /// No description provided for @startupErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'\'t load your data'**
  String get startupErrorTitle;

  /// No description provided for @startupErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check the local storage and try again. Your existing data has not been changed.'**
  String get startupErrorBody;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// Accessible onboarding page position
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboardingPageSemantics(int current, int total);

  /// No description provided for @onboardingOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Make space for what matters'**
  String get onboardingOneTitle;

  /// No description provided for @onboardingOneBody.
  ///
  /// In en, this message translates to:
  /// **'Turn your plans into a calm, focused list for each day.'**
  String get onboardingOneBody;

  /// No description provided for @onboardingTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Build momentum, one check at a time'**
  String get onboardingTwoTitle;

  /// No description provided for @onboardingTwoBody.
  ///
  /// In en, this message translates to:
  /// **'See progress at a glance and keep your completion streak moving.'**
  String get onboardingTwoBody;

  /// No description provided for @onboardingThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Private by design'**
  String get onboardingThreeTitle;

  /// No description provided for @onboardingThreeBody.
  ///
  /// In en, this message translates to:
  /// **'Everything is stored locally. No account, cloud, or tracking required.'**
  String get onboardingThreeBody;

  /// No description provided for @onboardingSaveError.
  ///
  /// In en, this message translates to:
  /// **'Your onboarding choice couldn\'\'t be saved. Please try again.'**
  String get onboardingSaveError;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @dashboardEyebrow.
  ///
  /// In en, this message translates to:
  /// **'YOUR DAY'**
  String get dashboardEyebrow;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily progress'**
  String get progressTitle;

  /// Whole number percentage
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String percentValue(int percent);

  /// Completed tasks count
  ///
  /// In en, this message translates to:
  /// **'{completed, plural, =0{No tasks done} =1{1 task done} other{{completed} tasks done}}'**
  String completedCount(int completed);

  /// Accessible daily task progress
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} tasks complete, {percent} percent'**
  String progressSemantics(int completed, int total, int percent);

  /// No description provided for @streakTitle.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get streakTitle;

  /// Number of consecutive completion days
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Start today} =1{1 day} other{{days} days}}'**
  String streakDays(int days);

  /// No description provided for @streakBody.
  ///
  /// In en, this message translates to:
  /// **'A day counts when you complete at least one task.'**
  String get streakBody;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// Task category totals
  ///
  /// In en, this message translates to:
  /// **'{open} open · {total} total'**
  String categorySummary(int open, int total);

  /// Accessible category summary card
  ///
  /// In en, this message translates to:
  /// **'{category}, {summary}'**
  String categoryCardSemantics(String category, String summary);

  /// No description provided for @todaysTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'\'s tasks'**
  String get todaysTasksTitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @todayEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your day is open'**
  String get todayEmptyTitle;

  /// No description provided for @todayEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a task when you\'\'re ready to give the day some direction.'**
  String get todayEmptyBody;

  /// No description provided for @allDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything is checked off'**
  String get allDoneTitle;

  /// No description provided for @allDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Nice work. Take a breath or get a head start on tomorrow.'**
  String get allDoneBody;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'All tasks'**
  String get tasksTitle;

  /// Total task count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No tasks} =1{1 task} other{{count} tasks}}'**
  String taskCount(int count);

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get addTask;

  /// No description provided for @addTaskTooltip.
  ///
  /// In en, this message translates to:
  /// **'Create a new task'**
  String get addTaskTooltip;

  /// No description provided for @createTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get createTaskTitle;

  /// No description provided for @editTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTaskTitle;

  /// No description provided for @taskMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get taskMissingTitle;

  /// No description provided for @taskMissingBody.
  ///
  /// In en, this message translates to:
  /// **'This task may have been deleted. Return to your task list to continue.'**
  String get taskMissingBody;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search title or description'**
  String get searchHint;

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search tasks'**
  String get searchTooltip;

  /// No description provided for @clearSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearchTooltip;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @filterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterCategory;

  /// No description provided for @filterPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get filterPriority;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get filterOpen;

  /// No description provided for @filterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get filterCompleted;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @allPriorities.
  ///
  /// In en, this message translates to:
  /// **'All priorities'**
  String get allPriorities;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get resetFilters;

  /// Title of a filter selection sheet
  ///
  /// In en, this message translates to:
  /// **'Choose {filterName}'**
  String chooseFilterTitle(String filterName);

  /// No description provided for @noTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTasksTitle;

  /// No description provided for @noTasksBody.
  ///
  /// In en, this message translates to:
  /// **'Create your first task and start building momentum.'**
  String get noTasksBody;

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching tasks'**
  String get noResultsTitle;

  /// No description provided for @noResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or reset your filters.'**
  String get noResultsBody;

  /// No description provided for @completeTaskTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mark task complete'**
  String get completeTaskTooltip;

  /// No description provided for @reopenTaskTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reopen task'**
  String get reopenTaskTooltip;

  /// No description provided for @taskMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Task actions'**
  String get taskMenuTooltip;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @deleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete task?'**
  String get deleteTaskTitle;

  /// Task deletion confirmation
  ///
  /// In en, this message translates to:
  /// **'“{title}” will be permanently removed from this device.'**
  String deleteTaskBody(String title);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteConfirm;

  /// Accessible open task status
  ///
  /// In en, this message translates to:
  /// **'{title}, open'**
  String taskOpenSemantics(String title);

  /// Accessible completed task status
  ///
  /// In en, this message translates to:
  /// **'{title}, completed'**
  String taskCompletedSemantics(String title);

  /// No description provided for @categoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get categoryWork;

  /// No description provided for @categoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get categoryPersonal;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get categoryLearning;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dueToday;

  /// Combined task due date and time
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String dateAtTime(String date, String time);

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get taskTitleLabel;

  /// No description provided for @taskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What do you want to move forward?'**
  String get taskTitleHint;

  /// No description provided for @taskDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get taskDescriptionLabel;

  /// No description provided for @taskDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes or context'**
  String get taskDescriptionHint;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time (optional)'**
  String get timeLabel;

  /// No description provided for @chooseDateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Choose due date'**
  String get chooseDateTooltip;

  /// No description provided for @chooseTimeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Choose due time'**
  String get chooseTimeTooltip;

  /// No description provided for @removeTime.
  ///
  /// In en, this message translates to:
  /// **'Remove time'**
  String get removeTime;

  /// No description provided for @saveTask.
  ///
  /// In en, this message translates to:
  /// **'Save task'**
  String get saveTask;

  /// No description provided for @savingTask.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingTask;

  /// No description provided for @validationTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title.'**
  String get validationTitleRequired;

  /// Task title maximum length validation
  ///
  /// In en, this message translates to:
  /// **'Use no more than {max} characters.'**
  String validationTitleTooLong(int max);

  /// Task description maximum length validation
  ///
  /// In en, this message translates to:
  /// **'Use no more than {max} characters.'**
  String validationDescriptionTooLong(int max);

  /// No description provided for @taskSaveError.
  ///
  /// In en, this message translates to:
  /// **'The task couldn\'\'t be saved. Please try again.'**
  String get taskSaveError;

  /// No description provided for @taskDeleteError.
  ///
  /// In en, this message translates to:
  /// **'The task couldn\'\'t be deleted. Please try again.'**
  String get taskDeleteError;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @appearanceBody.
  ///
  /// In en, this message translates to:
  /// **'Choose how Momentum looks on this device.'**
  String get appearanceBody;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Local & private'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'Tasks and preferences are stored only on this device. Momentum sends no data to a server.'**
  String get privacyBody;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Momentum'**
  String get aboutTitle;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get versionLabel;

  /// No description provided for @settingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Your setting couldn\'\'t be saved. The previous choice is still active.'**
  String get settingsSaveError;

  /// No description provided for @closeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeTooltip;

  /// No description provided for @backTooltip.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get backTooltip;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
