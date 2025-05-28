import 'package:intl/intl.dart';

/// Formats a Duration component (hours, minutes, seconds) with padding.
String formatTimerUnit(int value) {
  return value.toString().padLeft(2, '0');
}

extension DurationFormatting on Duration {
  String get hoursFormatted => formatTimerUnit(inHours);
  String get minutesFormatted => formatTimerUnit(inMinutes.remainder(60));
  String get secondsFormatted => formatTimerUnit(inSeconds.remainder(60));

  String get timeAgo => DateHelpers.getTimeAgo(this);
}

class DateHelpers {
  DateHelpers._();

  static String getTimeAgo(Duration elapsedTime) {
    final now = DateTime.now();
    final startTime = now.subtract(elapsedTime);
    final difference = now.difference(startTime);

    final days = difference.inDays;
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    if (days > 0) {
      return 'Started $days days ago';
    } else if (hours > 0) {
      return 'Started $hours hours ago';
    } else if (minutes > 0) {
      return 'Started $minutes mins ago';
    } else {
      return 'Just now';
    }
  }

  static String calculateTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    final days = difference.inDays;
    final hours = difference.inHours;
    final mins = difference.inMinutes.remainder(60);
    final secs = difference.inSeconds;

    if (days > 0) {
      return Intl.plural(days, other: '$days days ago', one: '1 day ago');
    } else if (hours > 0) {
      return Intl.plural(hours, other: '$hours hours ago', one: '1 hour ago');
    } else if (mins > 0) {
      return Intl.plural(mins, other: '$mins mins ago', one: '1 min ago');
    } else {
      return Intl.plural(secs, other: '$secs seconds ago', one: 'Just now');
    }
  }

  static String getTotalBroadcastTime({
    required DateTime startTime,
    required DateTime endTime,
  }) {
    final difference = startTime.difference(endTime);
    final mins = difference.inMinutes;
    if (mins < 1) {
      return 'Less than a minute';
    } else {
      return Intl.plural(mins, other: '$mins mins', one: '$mins minute');
    }
  }
}
