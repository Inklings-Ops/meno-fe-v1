import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/domain.dart';
import 'package:meno/shared/infrastructure/dtos/general_settings_dto.dart';
import 'package:meno/utils/enum_utils.dart';

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

  factory UserDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON type for UserDto: $json');
    }

    return UserDto(
      id: json[_kId] as String,
      fullName: json[_kFullName] as String,
      email: json[_kEmail] as String,
      bio: json[_kBio] as String?,
      generalSettings: json[_kGeneralSettings] != null
          ? GeneralSettingsDto.fromJson(json[_kGeneralSettings])
          : null,
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
      imageId: json[_kImageId] as String?,
      imageUrl: json[_kImageUrl] as String?,
      verified: json[_kVerified] as bool,
      emailAccountType: json[_kEmailAccountType] as String?,
    );
  }

  static const _kId = 'id';
  static const _kFullName = 'fullName';
  static const _kEmail = 'email';
  static const _kBio = 'bio';
  static const _kGeneralSettings = 'generalSettings';
  static const _kRole = 'role';
  static const _kImageId = 'imageId';
  static const _kImageUrl = 'imageUrl';
  static const _kVerified = 'verified';
  static const _kEmailAccountType = 'emailAccountType';

  Map<String, dynamic> toJson() {
    return {
      _kId: id,
      _kFullName: fullName,
      _kEmail: email,
      _kBio: bio,
      _kGeneralSettings: generalSettings?.toJson(),
      _kRole: _$UserRoleEnumMap[role],
      _kImageId: imageId,
      _kImageUrl: imageUrl,
      _kVerified: verified,
      _kEmailAccountType: emailAccountType,
    };
  }

  final String id;
  final String fullName;
  final String email;
  final String? bio;
  final GeneralSettingsDto? generalSettings;
  final UserRole? role;
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
      id: Id.fromString(id),
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
      id: id.getOrElse((_) => ''),
      email: email.getOrElse((_) => ''),
      fullName: fullName.getOrElse((_) => ''),
      bio: bio?.getOrElse((_) => ''),
      generalSettings: generalSettings?.toDto,
      role: role,
      emailAccountType: emailAccountType,
      imageId: imageId,
      imageUrl: imageUrl,
      verified: verified,
    );
  }
}

const _$UserRoleEnumMap = {UserRole.admin: 'admin', UserRole.guest: 'guest'};
