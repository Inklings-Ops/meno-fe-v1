import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/settings/infrastructure/infrastructure.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'user_dto.g.dart';

@JsonSerializable()
final class UserDto with EquatableMixin {
  const UserDto({
    required this.id,
    required this.fullName,
    required this.email,
    this.generalSettings,
    this.bio,
    this.role,
    this.imageId,
    this.imageUrl,
    this.verified = false,
    this.emailAccountType,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  final String id;
  final String fullName;
  final String email;
  final String? bio;
  final GeneralSettingsDto? generalSettings;
  final AuthRole? role;
  final String? imageId;
  final String? imageUrl;
  final bool verified;
  final String? emailAccountType;

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    bio,
    generalSettings,
    role,
    imageId,
    imageUrl,
    verified,
    emailAccountType,
  ];

  @override
  bool get stringify => true;
}

extension UserDtoX on UserDto {
  UserDto get stripped {
    return UserDto(
      id: id,
      fullName: fullName,
      email: email,
      imageUrl: imageUrl,
    );
  }

  User get toDomain {
    return User(
      id: ID.fromString(id),
      email: Email(email),
      fullName: SingleLineString(fullName),
      bio: bio == null ? null : MultiLineString(bio!),
      generalSettings: generalSettings?.toDomain,
      role: role,
      emailAccountType: emailAccountType,
      imageId: imageId,
      imageUrl: imageUrl,
      verified: verified,
    );
  }
}

extension UserToDomainX on User {
  UserDto get toDto {
    return UserDto(
      id: id.getOrElse(() => ''),
      email: email.getOrElse(() => ''),
      fullName: fullName.getOrElse(() => ''),
      bio: bio?.getOrElse(() => ''),
      generalSettings: generalSettings?.toDto,
      role: role,
      emailAccountType: emailAccountType,
      imageId: imageId,
      imageUrl: imageUrl,
      verified: verified,
    );
  }
}
