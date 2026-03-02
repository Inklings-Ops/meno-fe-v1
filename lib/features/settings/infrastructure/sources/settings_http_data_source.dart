import 'package:dio/dio.dart' show CancelToken;
import 'package:meno/core/core.dart';
import 'package:meno/features/settings/infrastructure/dtos/user_settings_dto.dart';

class SettingsHttpDataSource {
  const SettingsHttpDataSource(this._client);

  final ApiClient _client;

  Future<UserSettingsDto> getUserSettings({CancelToken? cancelToken}) {
    return _client.get(
      '/settings',
      fromJson: UserSettingsDto.fromJson,
      cancelToken: cancelToken,
    );
  }
}
