import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/profile/infrastructure/dtos/profile_dto.dart';
import 'package:meno_fe_v1/src/services/secure_storage_service.dart';
import 'package:meno_fe_v1/src/shared/m_keys.dart';

/// A local data source for profile of the user.
@injectable
class ProfileLocalDatasource {
  /// Creates a new `ProfileLocalDatasource` object.
  ProfileLocalDatasource({required SecureStorageService storage})
      : _storage = storage;

  /// The secure storage service.
  final SecureStorageService _storage;

  Future<void> deleteProfile() => _storage.delete(MKeys.authUserProfileKey);

  Future<ProfileDto?> getProfile() async {
    try {
      final encodedString = await _storage.read(MKeys.authUserProfileKey);
      if (encodedString?.isEmpty ?? true) return null;

      final json = jsonDecode(encodedString!) as Map<String, dynamic>;
      return ProfileDto.fromJson(json);
    } on Exception {
      rethrow;
    }
  }

  Future<void> saveProfile(ProfileDto profile) async {
    try {
      final value = jsonEncode(profile.stripped);
      await _storage.write(MKeys.authUserProfileKey, value: value);
    } on Exception {
      rethrow;
    }
  }
}
