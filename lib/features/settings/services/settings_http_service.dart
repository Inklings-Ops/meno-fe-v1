import 'package:dio/dio.dart' show CancelToken;
import 'package:meno/_shared/services/http_client.dart';
import 'package:meno/features/settings/model/_model.dart';

class SettingsHttpService {
  const SettingsHttpService(this._client);

  final HttpClient _client;

  Future<UserSettingsDto> getUserSettings({CancelToken? cancelToken}) {
    return _client.get(
      '/settings',
      fromJson: UserSettingsDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  Future<UserSettingsDto> updateUserSettings({
    String? display,
    String? language,
    bool? appNotifications,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? userSubscribed,
    bool? addedAsCoHost,
    bool? liveBroadcastStarted,
    bool? scheduledBroadcast,
    CancelToken? cancelToken,
  }) async {
    final notificationSettings = <String, dynamic>{
      if (userSubscribed != null) 'userSubscribed': userSubscribed,
      if (addedAsCoHost != null) 'addedAsCoHost': addedAsCoHost,
      if (liveBroadcastStarted != null)
        'liveBroadcastStarted': liveBroadcastStarted,
      if (scheduledBroadcast != null) 'scheduledBroadcast': scheduledBroadcast,
    };

    final data = <String, dynamic>{
      if (display != null) 'display': display,
      if (language != null) 'language': language,
      if (appNotifications != null) 'appNotifications': appNotifications,
      if (pushNotifications != null) 'pushNotifications': pushNotifications,
      if (emailNotifications != null) 'emailNotifications': emailNotifications,
      if (notificationSettings.isNotEmpty)
        'notificationSettings': notificationSettings,
    };

    return _client.put(
      '/settings',
      data: data,
      fromJson: UserSettingsDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  Future<UserSettingsDto> syncSettings(UserSettingsDto dto) {
    return _client.put(
      '/settings',
      data: dto.toJson(),
      fromJson: UserSettingsDto.fromJson,
    );
  }
}
