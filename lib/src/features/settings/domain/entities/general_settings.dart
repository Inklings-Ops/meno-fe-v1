import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/settings/domain/entities/notification_setting.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

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

  final ID id;
  final ID userId;
  final List<NotificationSetting> notificationSettings;
  final bool pushNotifications;
  final bool appNotifications;
  final bool emailNotifications;
  final String display;
  final String language;
  final String? pushNotificationToken;

  GeneralSettings copyWith({
    ID? id,
    ID? userId,
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

  @override
  bool get stringify => true;
}
