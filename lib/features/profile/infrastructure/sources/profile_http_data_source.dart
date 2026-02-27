import 'package:dio/dio.dart' show CancelToken;
import 'package:meno/core/core.dart';
import 'package:meno/features/profile/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

class ProfileHttpDataSource {
  const ProfileHttpDataSource(this._client);

  final ApiClient _client;

  Future<ProfileDto?> getProfile(
    String userId, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/users/$userId/profile',
      fromJson: ProfileDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  Future<PagedList<ProfileDto?>> getProfiles(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/users/profiles',
      cancelToken: cancelToken,
      queryParameters: queryParameters,
      fromJson: (json) => PagedList<ProfileDto?>.fromJson(
        json,
        ProfileDto.fromJson,
        listKey: 'users',
      ),
    );
  }
}
