import 'package:meno/features/settings/model/entities/_entities.dart';

class UserNotificationSettingsDto {
  const UserNotificationSettingsDto({
    this.addedAsCoHost = false,
    this.userSubscribed = false,
    this.scheduledBroadcast = false,
    this.liveBroadcastStarted = false,
  });

  factory UserNotificationSettingsDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid UserNotificationSettings JSON');
    }

    return UserNotificationSettingsDto(
      addedAsCoHost: (json[_kAddedAsCoHost] as bool?) ?? false,
      userSubscribed: (json[_kUserSubscribed] as bool?) ?? false,
      scheduledBroadcast: (json[_kScheduledBroadcast] as bool?) ?? false,
      liveBroadcastStarted: (json[_kLiveBroadcastStarted] as bool?) ?? false,
    );
  }

  final bool addedAsCoHost;
  final bool userSubscribed;
  final bool scheduledBroadcast;
  final bool liveBroadcastStarted;

  static const String _kAddedAsCoHost = 'addedAsCoHost';
  static const String _kUserSubscribed = 'userSubscribed';
  static const String _kScheduledBroadcast = 'scheduledBroadcast';
  static const String _kLiveBroadcastStarted = 'liveBroadcastStarted';

  Map<String, dynamic> toJson() => {
    _kAddedAsCoHost: addedAsCoHost,
    _kUserSubscribed: userSubscribed,
    _kScheduledBroadcast: scheduledBroadcast,
    _kLiveBroadcastStarted: liveBroadcastStarted,
  };
}

extension UserNotificationSettingsDtoX on UserNotificationSettings {
  UserNotificationSettingsDto get toDto => UserNotificationSettingsDto(
    addedAsCoHost: addedAsCoHost,
    userSubscribed: userSubscribed,
    scheduledBroadcast: scheduledBroadcast,
    liveBroadcastStarted: liveBroadcastStarted,
  );
}

extension UserNotificationSettingsX on UserNotificationSettingsDto {
  UserNotificationSettings get toDomain => UserNotificationSettings(
    addedAsCoHost: addedAsCoHost,
    userSubscribed: userSubscribed,
    scheduledBroadcast: scheduledBroadcast,
    liveBroadcastStarted: liveBroadcastStarted,
  );
}
