import 'package:equatable/equatable.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/_shared/models/notification_setting.dart';
import 'package:meno/_shared/models/user_display.dart';

final class GeneralSettings with EquatableMixin {
  const GeneralSettings({
    required this.id,
    required this.userId,
    required this.notificationSettings,
    this.pushNotifications = false,
    this.appNotifications = true,
    this.emailNotifications = false,
    this.display = UserDisplay.system,
    this.language = 'en/English',
    this.pushNotificationToken,
  });

  final Id id;
  final Id userId;
  final List<NotificationSetting> notificationSettings;
  final bool pushNotifications;
  final bool appNotifications;
  final bool emailNotifications;
  final UserDisplay display;
  final String language;
  final String? pushNotificationToken;

  GeneralSettings copyWith({
    Id? id,
    Id? userId,
    List<NotificationSetting>? notificationSettings,
    bool? pushNotifications,
    bool? appNotifications,
    bool? emailNotifications,
    UserDisplay? display,
    String? language,
    String? pushNotificationToken,
  }) {
    return GeneralSettings(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      appNotifications: appNotifications ?? this.appNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      display: display ?? this.display,
      language: language ?? this.language,
      pushNotificationToken:
          pushNotificationToken ?? this.pushNotificationToken,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    notificationSettings,
    pushNotifications,
    appNotifications,
    emailNotifications,
    display,
    language,
    pushNotificationToken,
  ];
}
