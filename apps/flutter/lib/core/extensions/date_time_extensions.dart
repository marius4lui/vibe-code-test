import 'package:intl/intl.dart';

import 'package:momentum/l10n/app_localizations.dart';

/// Locale-aware date and time formatting for presentation code.
extension DateTimeFormatting on DateTime {
  DateTime get localDayStart {
    final local = toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  bool isSameLocalDay(DateTime other) => localDayStart == other.localDayStart;

  String formatShortDate(AppLocalizations l10n) {
    return DateFormat.yMMMd(l10n.localeName).format(toLocal());
  }

  String formatLongDate(AppLocalizations l10n) {
    return DateFormat.yMMMMEEEEd(l10n.localeName).format(toLocal());
  }

  String formatTime(AppLocalizations l10n) {
    return DateFormat.jm(l10n.localeName).format(toLocal());
  }

  String formatDateTime(AppLocalizations l10n) {
    return DateFormat.yMMMd(l10n.localeName).add_jm().format(toLocal());
  }
}
