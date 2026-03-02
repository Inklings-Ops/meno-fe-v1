import 'package:equatable/equatable.dart';
import 'package:meno/features/settings/domain/entities/user_notification_settings.dart';
import 'package:meno/shared/shared.dart';

sealed class Settings {
  const Settings({
    this.display = UserDisplay.system,
    this.language = 'en/English',
    this.appNotifications = false,
    this.pushNotifications = false,
    this.emailNotifications = false,
    this.notificationSettings = const UserNotificationSettings(),
  });

  final UserDisplay display;
  final String language;
  final bool appNotifications;
  final bool pushNotifications;
  final bool emailNotifications;
  final UserNotificationSettings notificationSettings;
}

final class UserSettings extends Settings with EquatableMixin {
  const UserSettings({
    super.display = UserDisplay.system,
    super.language = 'en/English',
    super.appNotifications = false,
    super.pushNotifications = false,
    super.emailNotifications = false,
    super.notificationSettings = const UserNotificationSettings(),
  });

  factory UserSettings.fromGeneralSettings(GeneralSettings settings) {
    return UserSettings(
      display: settings.display,
      appNotifications: settings.appNotifications,
      emailNotifications: settings.emailNotifications,
      language: settings.language,
      pushNotifications: settings.pushNotifications,
    );
  }

  @override
  List<Object?> get props => [
    display,
    language,
    appNotifications,
    pushNotifications,
    emailNotifications,
    notificationSettings,
  ];

  UserSettings copyWith({
    UserDisplay? display,
    String? language,
    bool? appNotifications,
    bool? pushNotifications,
    bool? emailNotifications,
    UserNotificationSettings? notificationSettings,
  }) {
    return UserSettings(
      display: display ?? this.display,
      language: language ?? this.language,
      appNotifications: appNotifications ?? this.appNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      notificationSettings: notificationSettings ?? this.notificationSettings,
    );
  }
}

final class GuestsSettings extends Settings with EquatableMixin {
  const GuestsSettings({
    super.display = UserDisplay.system,
    super.language = 'en/English',
  });

  @override
  List<Object?> get props => [display, language];
}
