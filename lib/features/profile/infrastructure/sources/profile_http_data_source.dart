import 'dart:io';

import 'package:dio/dio.dart' show CancelToken, FormData, MultipartFile;
import 'package:meno/core/core.dart';
import 'package:meno/features/profile/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

/// Remote data source for the profile feature.
///
/// Wraps every API call the profile domain needs:
/// - Own profile: get, edit
/// - Browse profiles: paginated list
/// - Subscribers / Subscriptions: paginated lists
/// - Subscribe / Unsubscribe actions
/// - Favorites: list, add, remove
/// - Recordings: list
///
/// All methods throw [MenoException] on failure — the repository layer
/// catches and converts to `Either`.
final class ProfileHttpDataSource {
  const ProfileHttpDataSource(this._client);

  final ApiClient _client;

  // =========================================================================
  // OWN PROFILE
  // =========================================================================

  /// Fetches the full profile for [userId].
  Future<ProfileDto?> getProfile(String userId, {CancelToken? cancelToken}) {
    return _client.get(
      '/users/$userId/profile',
      fromJson: ProfileDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  /// Updates the authenticated user's profile.
  ///
  /// Sends a `multipart/form-data` PUT so an optional [image] file can be
  /// included in the same request as the text fields.
  ///
  /// Returns the updated [ProfileDto] reflecting the server's persisted state.
  Future<ProfileDto> editProfile({
    required String userId,
    String? fullName,
    String? bio,
    File? image,
    CancelToken? cancelToken,
  }) async {
    final form = FormData();

    if (fullName != null) form.fields.add(MapEntry('fullName', fullName));
    if (bio != null) form.fields.add(MapEntry('bio', bio));
    if (image != null) {
      form.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }

    return _client.put(
      '/users/$userId/profile',
      data: form,
      fromJson: ProfileDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  // =========================================================================
  // PROFILE BROWSE
  // =========================================================================

  /// Returns a paginated list of user profiles.
  ///
  /// All filtering/sorting/pagination is expressed through [queryParameters]
  /// so the HTTP layer stays stable while the domain evolves.
  Future<PagedList<ProfileDto?>> getProfiles(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  }) {
    return _client.get(
      '/users/profiles',
      queryParameters: queryParameters,
      fromJson: (json) => PagedList<ProfileDto?>.fromJson(
        json,
        ProfileDto.fromJson,
        listKey: 'users',
      ),
      cancelToken: cancelToken,
    );
  }

  // =========================================================================
  // SUBSCRIBERS / SUBSCRIPTIONS
  // =========================================================================

  /// Returns a paginated list of users who subscribe to `subscriptionId`.
  Future<PagedList<ProfileDto?>> getSubscribers(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  }) {
    return _client.get(
      '/subscribers',
      queryParameters: queryParameters,
      fromJson: (json) => PagedList<ProfileDto?>.fromJson(
        json,
        ProfileDto.fromJson,
        listKey: 'subscribers',
      ),
      cancelToken: cancelToken,
    );
  }

  /// Returns a paginated list of users that `subscriberId` follows.
  Future<PagedList<ProfileDto?>> getSubscriptions(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  }) {
    return _client.get(
      '/subscribers',
      queryParameters: queryParameters,
      fromJson: (json) => PagedList<ProfileDto?>.fromJson(
        json,
        ProfileDto.fromJson,
        listKey: 'subscribers',
      ),
      cancelToken: cancelToken,
    );
  }

  /// Subscribes the authenticated user to [targetUserId].
  Future<void> subscribe(String targetUserId, {CancelToken? cancelToken}) {
    return _client.postUnit(
      '/subscribers',
      data: {'userId': targetUserId},
      cancelToken: cancelToken,
    );
  }

  /// Unsubscribes the authenticated user from [targetUserId].
  Future<void> unsubscribe(String targetUserId, {CancelToken? cancelToken}) {
    return _client.deleteUnit(
      '/subscribers',
      data: {'userId': targetUserId},
      cancelToken: cancelToken,
    );
  }
}
