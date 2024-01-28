import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../services/secure_storage_service.dart';
import '../../../../shared/m_keys.dart';
import '../../../auth/infrastructure/dtos/dtos.dart';
import '../dtos/profile_dto.dart';

/// A local data source for profile of the user.
@injectable
class ProfileLocalDatasource {
  /// The secure storage service.
  final SecureStorageService _storage;

  /// Creates a new `ProfileLocalDatasource` object.
  ProfileLocalDatasource({required SecureStorageService storage})
      : _storage = storage;

  Future<ProfileDto?> getProfile() async {
    final jsonString = await _storage.read(MKeys.authUserProfileKey);
    if (jsonString == null) return null;
    return ProfileDto.fromJson(jsonDecode(jsonString));
  }

  Future<UserCredentialDto?> getUserCredential() async {
    final jsonString = await _storage.read(MKeys.authUserCredentialKey);
    if (jsonString == null) return null;
    return UserCredentialDto.fromJson(jsonDecode(jsonString));
  }

  Future<bool> get hasLocalProfile => _storage.hasKey(MKeys.authUserProfileKey);

  Future<void> storeProfile(ProfileDto dto) async {
    final String encodedString = jsonEncode(dto.toJson());
    await _storage.write(MKeys.authUserProfileKey, value: encodedString);
  }
}
