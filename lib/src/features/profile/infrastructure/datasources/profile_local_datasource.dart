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

  Future<ProfileDto?> getProfile() async {
    final jsonString = await _storage.read(MKeys.authUserProfileKey);
    if (jsonString == null) return null;
    final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
    return ProfileDto.fromJson(decodedJson);
  }

  Future<String?> getAuthUserId() async {
    final authUserId = await _storage.read(MKeys.authUserId);
    return authUserId;
  }

  Future<bool> get hasLocalProfile => _storage.hasKey(MKeys.authUserProfileKey);

  Future<void> storeProfile(ProfileDto dto) async {
    final encodedString = jsonEncode(dto.toJson());
    await _storage.write(MKeys.authUserProfileKey, value: encodedString);
  }
}
