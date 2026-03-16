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

  Future<UserSettingsDto> updateUserSettings(
    UserSettingsPatch patch, {
    CancelToken? cancelToken,
  }) {
    assert(!patch.isEmpty, 'updateUserSettings called with an empty patch');

    return _client.patch(
      '/settings',
      data: patch.toJson(),
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
