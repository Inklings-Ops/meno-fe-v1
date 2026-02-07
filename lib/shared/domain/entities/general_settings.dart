import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/domain.dart';

final class GeneralSettings with EquatableMixin {
  const GeneralSettings({
    required this.id,
    required this.userId,
    required this.notificationSettings,
    this.pushNotifications = false,
    this.appNotifications = true,
    this.emailNotifications = false,
    this.display = 'light',
    this.language = 'en/English',
    this.pushNotificationToken,
  });

  final Id id;
  final Id userId;
  final List<NotificationSetting> notificationSettings;
  final bool pushNotifications;
  final bool appNotifications;
  final bool emailNotifications;
  final String display;
  final String language;
  final String? pushNotificationToken;

  GeneralSettings copyWith({
    Id? id,
    Id? userId,
    List<NotificationSetting>? notificationSettings,
    bool? pushNotifications,
    bool? appNotifications,
    bool? emailNotifications,
    String? display,
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
