import 'package:meno/src/_exceptions/exceptions.dart';
import 'package:meno/src/_shared/dtos/dtos.dart';
import 'package:meno/src/_shared/models/models.dart';

final class GeneralSettingsDto {
  const GeneralSettingsDto({
    required this.id,
    required this.userId,
    required this.notificationSettings,
    this.pushNotifications = false,
    this.appNotifications = true,
    this.emailNotifications = false,
    this.display = 'system',
    this.language = 'en/English',
    this.pushNotificationToken,
  });

  factory GeneralSettingsDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw FormatError<GeneralSettingsDto>();
    return GeneralSettingsDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      notificationSettings: (json['notificationSettings'] as List<dynamic>)
          .map(NotificationSettingDto.fromJson)
          .toList(),
      pushNotifications: json['pushNotifications'] as bool? ?? false,
      appNotifications: json['appNotifications'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? false,
      display: json['display'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en/English',
      pushNotificationToken: json['pushNotificationToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'notificationSettings': notificationSettings
          .map((n) => n.toJson())
          .toList(),
      'pushNotifications': pushNotifications,
      'appNotifications': appNotifications,
      'emailNotifications': emailNotifications,
      'display': display,
      'language': language,
      'pushNotificationToken': pushNotificationToken,
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
}

extension GeneralSettingsDtoX on GeneralSettingsDto {
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
      display: UserDisplay.fromString(display),
      language: language,
      pushNotificationToken: pushNotificationToken,
    );
  }
}

extension GeneralSettingsX on GeneralSettings {
  GeneralSettingsDto get toDto {
    return GeneralSettingsDto(
      id: id.getOrCrash(),
      userId: userId.getOrCrash(),
      notificationSettings: notificationSettings.map((n) => n.toDto).toList(),
      pushNotifications: pushNotifications,
      appNotifications: appNotifications,
      emailNotifications: emailNotifications,
      display: display.value,
      language: language,
      pushNotificationToken: pushNotificationToken,
    );
  }
}
