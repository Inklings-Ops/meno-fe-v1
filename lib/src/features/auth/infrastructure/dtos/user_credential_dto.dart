import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/features/auth/infrastructure/dtos/user_dto.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'user_credential_dto.freezed.dart';
part 'user_credential_dto.g.dart';

/// A data transfer object (DTO) representing a user's credentials.
@freezed
@JsonSerializable(explicitToJson: true, createFactory: false)
class UserCredentialDto with _$UserCredentialDto {
  /// Creates a new `UserCredentialDto` object.
  factory UserCredentialDto({
    /// The user's DTO.
    required UserDto user,

    /// The user's token.
    String? token,
  }) = _UserCredentialDto;

  /// Creates a new `UserCredentialDto` object from a JSON map.
  factory UserCredentialDto.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialDtoFromJson(json);

  /// Converts the `UserCredentialDto` object to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$UserCredentialDtoToJson(this);
}

extension UserCredentialDtoToDomain on UserCredentialDto {
  UserCredential get toDomain {
    return UserCredential(
      user: user.toDomain,
      token: token == null ? null : Token(token!),
    );
  }
}

extension UserCredentialToDto on UserCredential {
  UserCredentialDto get toDto {
    return UserCredentialDto(
      user: user.toDto,
      token: token?.getOr(),
    );
  }
}
