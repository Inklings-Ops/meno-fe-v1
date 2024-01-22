import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';
import '../dtos/dtos.dart';

/// A class for mapping between `UserCredentials` and `User` domain objects and `UserCredentialDto` and `User` DTOs.
@singleton
class AuthMapper {
  /// Converts a `UserDto` DTO to a `User` domain object.
  User? userToDomain(UserDto? dto) {
    if (dto == null) return null;
    return User(
      id: dto.id,
      fullName: IFullName(dto.fullName),
      email: IEmail(dto.email),
      bio: dto.bio != null ? IBio(dto.bio!) : null,
      emailAccountType: dto.emailAccountType,
      verified: dto.verified,
      imageId: dto.imageId,
      imageUrl: dto.imageUrl,
      deleted: dto.deleted,
    );
  }

  /// Converts a `User` domain object to a `UserDto` DTO.
  UserDto? userToDto(User? domain) {
    if (domain == null) return null;
    return UserDto(
      id: domain.id,
      fullName: domain.fullName.get()!,
      email: domain.email.get()!,
      bio: domain.bio?.get(),
      emailAccountType: domain.emailAccountType,
      verified: domain.verified,
      imageId: domain.imageId,
      imageUrl: domain.imageUrl,
      deleted: domain.deleted,
    );
  }

  UserCredentialDto? userCredentialsToDto(UserCredential? domain) {
    if (domain == null) return null;
    return UserCredentialDto(
      user: userToDto(domain.user)!,
      token: domain.token,
    );
  }

  UserCredential? userCredentialsToDomain(UserCredentialDto? dto) {
    if (dto == null) return null;
    return UserCredential(
      user: userToDomain(dto.user)!,
      token: dto.token,
    );
  }
}
