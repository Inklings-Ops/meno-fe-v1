import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/settings/model/dtos/_dtos.dart';
import 'package:meno/features/settings/model/entities/_entities.dart';

class UserSettingsDto {
  const UserSettingsDto({
    this.display = UserDisplay.system,
    this.language = 'en/English',
    this.appNotifications = false,
    this.pushNotifications = false,
    this.emailNotifications = false,
    this.notificationSettings = const UserNotificationSettingsDto(),
  });

  factory UserSettingsDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid UserSettingsDto JSON');
    }

    return UserSettingsDto(
      display: UserDisplay.fromJson(json[_kDisplay]),
      language: (json[_kLanguage] as String?) ?? 'en/English',
      appNotifications: (json[_kAppNotifications] as bool?) ?? false,
      pushNotifications: (json[_kPushNotifications] as bool?) ?? false,
      emailNotifications: (json[_kEmailNotifications] as bool?) ?? false,
      notificationSettings: UserNotificationSettingsDto.fromJson(
        json[_kNotificationSettings],
      ),
    );
  }

  final UserDisplay display;
  final String language;
  final bool appNotifications;
  final bool pushNotifications;
  final bool emailNotifications;
  final UserNotificationSettingsDto notificationSettings;

  static const _kDisplay = 'display';
  static const _kLanguage = 'language';
  static const _kAppNotifications = 'appNotifications';
  static const _kPushNotifications = 'pushNotifications';
  static const _kEmailNotifications = 'emailNotifications';
  static const _kNotificationSettings = 'notificationSettings';

  Map<String, dynamic> toJson() => {
    _kDisplay: display.value,
    _kLanguage: language,
    _kAppNotifications: appNotifications,
    _kPushNotifications: pushNotifications,
    _kEmailNotifications: emailNotifications,
    _kNotificationSettings: notificationSettings.toJson(),
  };
}

extension UserSettingsDtoX on UserSettings {
  UserSettingsDto get toDto => UserSettingsDto(
    display: display,
    language: language,
    appNotifications: appNotifications,
    pushNotifications: pushNotifications,
    emailNotifications: emailNotifications,
    notificationSettings: notificationSettings.toDto,
  );
}

extension UserSettingsX on UserSettingsDto {
  UserSettings get toDomain => UserSettings(
    display: display,
    language: language,
    appNotifications: appNotifications,
    pushNotifications: pushNotifications,
    emailNotifications: emailNotifications,
    notificationSettings: notificationSettings.toDomain,
  );
}
