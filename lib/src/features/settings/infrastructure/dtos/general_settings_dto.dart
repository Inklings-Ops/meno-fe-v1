import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/settings/domain/entities/entities.dart';
import 'package:meno_fe_v1/src/features/settings/infrastructure/dtos/notification_setting_dto.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'general_settings_dto.g.dart';

@JsonSerializable()
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

  factory GeneralSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$GeneralSettingsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralSettingsDtoToJson(this);

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

  @override
  bool get stringify => true;
}

extension GeneralSettingsX on GeneralSettingsDto {
  GeneralSettings get toDomain {
    return GeneralSettings(
      id: ID.fromString(id),
      userId: ID.fromString(userId),
      notificationSettings:
          notificationSettings.map((n) => n.toDomain).toList(),
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
      id: id.getOrElse(() => ''),
      userId: userId.getOrElse(() => ''),
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
