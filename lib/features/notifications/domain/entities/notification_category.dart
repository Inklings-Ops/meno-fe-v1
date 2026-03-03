enum NotificationCategory { today, thisWeek, older, none }

extension NotificationCategoryX on NotificationCategory {
  String get toName => switch (this) {
    NotificationCategory.none => 'None',
    NotificationCategory.today => 'Today',
    NotificationCategory.older => 'Older',
    NotificationCategory.thisWeek => 'This Week',
  };
}
