import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/domain.dart';
import 'package:meno/shared/infrastructure/dtos/notification_setting_dto.dart';

final class GeneralSettingsDto with EquatableMixin {
  const GeneralSettingsDto({
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

  factory GeneralSettingsDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON type for GeneralSettingsDto: $json');
    }

    return GeneralSettingsDto(
      id: json[_kId] as String,
      userId: json[_kUserId] as String,
      notificationSettings: (json[_kNotificationSettings] as List<dynamic>)
          .map(NotificationSettingDto.fromJson)
          .toList(),
      pushNotifications: json[_kPushNotifications] as bool,
      appNotifications: json[_kAppNotifications] as bool,
      emailNotifications: json[_kEmailNotifications] as bool,
      display: json[_kDisplay] as String,
      language: json[_kLanguage] as String,
      pushNotificationToken: json[_kPushNotificationToken] as String?,
    );
  }

  static const _kId = 'id';
  static const _kUserId = 'userId';
  static const _kNotificationSettings = 'notificationSettings';
  static const _kPushNotifications = 'pushNotifications';
  static const _kAppNotifications = 'appNotifications';
  static const _kEmailNotifications = 'emailNotifications';
  static const _kDisplay = 'display';
  static const _kLanguage = 'language';
  static const _kPushNotificationToken = 'pushNotificationToken';

  Map<String, dynamic> toJson() {
    return {
      _kId: id,
      _kUserId: userId,
      _kNotificationSettings: notificationSettings
          .map((n) => n.toJson())
          .toList(),
      _kPushNotifications: pushNotifications,
      _kAppNotifications: appNotifications,
      _kEmailNotifications: emailNotifications,
      _kDisplay: display,
      _kLanguage: language,
      _kPushNotificationToken: pushNotificationToken,
    };
  }

  final String id;
  final String userId;
  final List<NotificationSettingDto> notificationSettings;
  final bool pushNotifications;
  final bool appNotifications;
  final bool emailNotifications;
  final String display;
  final String language;
  final String? pushNotificationToken;

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

extension GeneralSettingsX on GeneralSettingsDto {
  GeneralSettings get toDomain {
    return GeneralSettings(
      id: Id.fromString(id),
      userId: Id.fromString(userId),
      notificationSettings: notificationSettings
          .map((n) => n.toDomain)
          .toList(),
      pushNotifications: pushNotifications,
      appNotifications: appNotifications,
      emailNotifications: emailNotifications,
      display: display,
      language: language,
      pushNotificationToken: pushNotificationToken,
    );
  }
}

extension GeneralSettingsDtoX on GeneralSettings {
  GeneralSettingsDto get toDto {
    return GeneralSettingsDto(
      id: id.getOrElse((_) => ''),
      userId: userId.getOrElse((_) => ''),
      notificationSettings: notificationSettings.map((n) => n.toDto).toList(),
      pushNotifications: pushNotifications,
      appNotifications: appNotifications,
      emailNotifications: emailNotifications,
      display: display,
      language: language,
      pushNotificationToken: pushNotificationToken,
    );
  }
}
