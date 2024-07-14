// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// A data transfer object (DTO) representing a user.
@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
sealed class UserDto with _$UserDto {
  /// Creates a new `UserDto` object.
  const factory UserDto({
    /// The user's ID.
    required String id,

    /// The user's full name.
    required String fullName,

    /// The user's email address.
    required String email,

    /// The user's bio.
    String? bio,

    /// The type of email account the user uses.
    String? emailAccountType,

    /// Whether the user's email address has been verified.
    bool? verified,

    /// The ID of the user's profile image.
    String? imageId,

    /// The URL of the user's profile image.
    String? imageUrl,

    /// Whether the user has been deleted.
    dynamic deleted,
  }) = _UserDto;

  /// Creates a new `UserDto` object from a JSON map.
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  /// Converts the `UserDto` object to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

extension UserDtoToDomain on UserDto {
  User get toDomain {
    return User(
      id: Uid.fromString(id),
      email: Email(email),
      fullName: SingleLineString(fullName),
      bio: bio == null ? null : Bio(bio!),
      deleted: deleted,
      emailAccountType: emailAccountType,
      imageId: imageId,
      imageUrl: imageUrl,
      verified: verified,
    );
  }
}

extension UserToDto on User {
  UserDto get toDto {
    return UserDto(
      id: id.getOr(),
      email: email.getOr(),
      fullName: fullName.getOr(),
      bio: bio?.getOr(),
      deleted: deleted,
      emailAccountType: emailAccountType,
      imageId: imageId,
      imageUrl: imageUrl,
      verified: verified,
    );
  }
}
