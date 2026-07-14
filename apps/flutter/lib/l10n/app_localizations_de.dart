// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Momentum';

  @override
  String get navToday => 'Heute';

  @override
  String get navTasks => 'Aufgaben';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get loadingTitle => 'Alles wird vorbereitet';

  @override
  String get loadingBody => 'Deine Aufgaben bleiben auf diesem Gerät.';

  @override
  String get loadingSemantics => 'Momentum wird geladen';

  @override
  String get startupErrorTitle => 'Deine Daten konnten nicht geladen werden';

  @override
  String get startupErrorBody =>
      'Prüfe den lokalen Speicher und versuche es erneut. Vorhandene Daten wurden nicht verändert.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get dismiss => 'Schließen';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingStart => 'Loslegen';

  @override
  String onboardingPageSemantics(int current, int total) {
    return 'Seite $current von $total';
  }

  @override
  String get onboardingOneTitle => 'Raum für das, was zählt';

  @override
  String get onboardingOneBody =>
      'Verwandle deine Pläne in eine ruhige, fokussierte Liste für jeden Tag.';

  @override
  String get onboardingTwoTitle => 'Momentum entsteht mit jedem Haken';

  @override
  String get onboardingTwoBody =>
      'Behalte deinen Fortschritt im Blick und setze deine Erfolgsserie fort.';

  @override
  String get onboardingThreeTitle => 'Privat von Grund auf';

  @override
  String get onboardingThreeBody =>
      'Alles wird lokal gespeichert. Kein Konto, keine Cloud und kein Tracking.';

  @override
  String get onboardingSaveError =>
      'Deine Auswahl konnte nicht gespeichert werden. Versuche es erneut.';

  @override
  String get todayTitle => 'Heute';

  @override
  String get dashboardEyebrow => 'DEIN TAG';

  @override
  String get progressTitle => 'Tagesfortschritt';

  @override
  String percentValue(int percent) {
    return '$percent %';
  }

  @override
  String completedCount(int completed) {
    String _temp0 = intl.Intl.pluralLogic(
      completed,
      locale: localeName,
      other: '$completed Aufgaben erledigt',
      one: '1 Aufgabe erledigt',
      zero: 'Noch nichts erledigt',
    );
    return '$_temp0';
  }

  @override
  String progressSemantics(int completed, int total, int percent) {
    return '$completed von $total Aufgaben erledigt, $percent Prozent';
  }

  @override
  String get streakTitle => 'Aktuelle Serie';

  @override
  String streakDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
      zero: 'Heute starten',
    );
    return '$_temp0';
  }

  @override
  String get streakBody => 'Ein Tag zählt, sobald du mindestens eine Aufgabe abschließt.';

  @override
  String get categoriesTitle => 'Kategorien';

  @override
  String categorySummary(int open, int total) {
    return '$open offen · $total gesamt';
  }

  @override
  String categoryCardSemantics(String category, String summary) {
    return '$category, $summary';
  }

  @override
  String get todaysTasksTitle => 'Aufgaben für heute';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get todayEmptyTitle => 'Dein Tag ist noch frei';

  @override
  String get todayEmptyBody =>
      'Füge eine Aufgabe hinzu, wenn du deinem Tag eine Richtung geben möchtest.';

  @override
  String get allDoneTitle => 'Alles erledigt';

  @override
  String get allDoneBody => 'Starke Arbeit. Atme durch oder starte schon entspannt in morgen.';

  @override
  String get tasksTitle => 'Alle Aufgaben';

  @override
  String taskCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '1 Aufgabe',
      zero: 'Keine Aufgaben',
    );
    return '$_temp0';
  }

  @override
  String get addTask => 'Aufgabe hinzufügen';

  @override
  String get addTaskTooltip => 'Neue Aufgabe erstellen';

  @override
  String get createTaskTitle => 'Neue Aufgabe';

  @override
  String get editTaskTitle => 'Aufgabe bearbeiten';

  @override
  String get taskMissingTitle => 'Aufgabe nicht gefunden';

  @override
  String get taskMissingBody =>
      'Diese Aufgabe wurde möglicherweise gelöscht. Kehre zu deiner Aufgabenliste zurück.';

  @override
  String get searchHint => 'Titel oder Beschreibung durchsuchen';

  @override
  String get searchTooltip => 'Aufgaben durchsuchen';

  @override
  String get clearSearchTooltip => 'Suche leeren';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterCategory => 'Kategorie';

  @override
  String get filterPriority => 'Priorität';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterOpen => 'Offen';

  @override
  String get filterCompleted => 'Erledigt';

  @override
  String get allCategories => 'Alle Kategorien';

  @override
  String get allPriorities => 'Alle Prioritäten';

  @override
  String get resetFilters => 'Filter zurücksetzen';

  @override
  String chooseFilterTitle(String filterName) {
    return '$filterName auswählen';
  }

  @override
  String get noTasksTitle => 'Noch keine Aufgaben';

  @override
  String get noTasksBody => 'Erstelle deine erste Aufgabe und bring Momentum in deinen Tag.';

  @override
  String get noResultsTitle => 'Keine passenden Aufgaben';

  @override
  String get noResultsBody => 'Probiere eine andere Suche oder setze die Filter zurück.';

  @override
  String get completeTaskTooltip => 'Aufgabe als erledigt markieren';

  @override
  String get reopenTaskTooltip => 'Aufgabe erneut öffnen';

  @override
  String get taskMenuTooltip => 'Aufgabenaktionen';

  @override
  String get editAction => 'Bearbeiten';

  @override
  String get deleteAction => 'Löschen';

  @override
  String get deleteTaskTitle => 'Aufgabe löschen?';

  @override
  String deleteTaskBody(String title) {
    return '„$title“ wird dauerhaft von diesem Gerät entfernt.';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get deleteConfirm => 'Löschen';

  @override
  String taskOpenSemantics(String title) {
    return '$title, offen';
  }

  @override
  String taskCompletedSemantics(String title) {
    return '$title, erledigt';
  }

  @override
  String get categoryWork => 'Arbeit';

  @override
  String get categoryPersonal => 'Privat';

  @override
  String get categoryHealth => 'Gesundheit';

  @override
  String get categoryLearning => 'Lernen';

  @override
  String get priorityLow => 'Niedrig';

  @override
  String get priorityMedium => 'Mittel';

  @override
  String get priorityHigh => 'Hoch';

  @override
  String get overdue => 'Überfällig';

  @override
  String get dueToday => 'Heute';

  @override
  String dateAtTime(String date, String time) {
    return '$date um $time';
  }

  @override
  String get taskTitleLabel => 'Titel';

  @override
  String get taskTitleHint => 'Was möchtest du voranbringen?';

  @override
  String get taskDescriptionLabel => 'Beschreibung (optional)';

  @override
  String get taskDescriptionHint => 'Notizen oder Kontext hinzufügen';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get priorityLabel => 'Priorität';

  @override
  String get dateLabel => 'Datum';

  @override
  String get timeLabel => 'Uhrzeit (optional)';

  @override
  String get chooseDateTooltip => 'Fälligkeitsdatum auswählen';

  @override
  String get chooseTimeTooltip => 'Uhrzeit auswählen';

  @override
  String get removeTime => 'Uhrzeit entfernen';

  @override
  String get saveTask => 'Aufgabe speichern';

  @override
  String get savingTask => 'Wird gespeichert…';

  @override
  String get validationTitleRequired => 'Gib einen Titel ein.';

  @override
  String validationTitleTooLong(int max) {
    return 'Verwende höchstens $max Zeichen.';
  }

  @override
  String validationDescriptionTooLong(int max) {
    return 'Verwende höchstens $max Zeichen.';
  }

  @override
  String get taskSaveError => 'Die Aufgabe konnte nicht gespeichert werden. Versuche es erneut.';

  @override
  String get taskDeleteError => 'Die Aufgabe konnte nicht gelöscht werden. Versuche es erneut.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get appearanceTitle => 'Darstellung';

  @override
  String get appearanceBody => 'Wähle, wie Momentum auf diesem Gerät aussieht.';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get privacyTitle => 'Lokal & privat';

  @override
  String get privacyBody =>
      'Aufgaben und Einstellungen werden nur auf diesem Gerät gespeichert. Momentum sendet keine Daten an einen Server.';

  @override
  String get aboutTitle => 'Über Momentum';

  @override
  String get versionLabel => 'Version 1.0.0';

  @override
  String get settingsSaveError =>
      'Die Einstellung konnte nicht gespeichert werden. Die vorherige Auswahl bleibt aktiv.';

  @override
  String get closeTooltip => 'Schließen';

  @override
  String get backTooltip => 'Zurück';
}
