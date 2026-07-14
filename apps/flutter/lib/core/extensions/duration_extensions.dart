/// Presentation-oriented duration labels without hard-coded language.
extension DurationFormatting on Duration {
  String get clockLabel {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String get compactClockLabel {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$inHours:$minutes';
  }

  String formatCompact({required String hourUnit, required String minuteUnit}) {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    if (hours == 0) return '$minutes $minuteUnit';
    if (minutes == 0) return '$hours $hourUnit';
    return '$hours $hourUnit $minutes $minuteUnit';
  }
}
