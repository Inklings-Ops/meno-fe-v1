import 'package:equatable/equatable.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';

final class UserDto with EquatableMixin {
  const UserDto({
    required this.id,
    required this.fullName,
    required this.email,
    this.generalSettings,
    this.bio,
    this.role = .guest,
    this.imageId,
    this.imageUrl,
    this.verified = false,
    this.emailAccountType,
  });

  factory UserDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw FormatError<UserDto>();
    return UserDto(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      generalSettings: json['generalSettings'] != null
          ? GeneralSettingsDto.fromJson(json['generalSettings'])
          : null,
      role: json['role'] != null
          ? UserRole.fromJson(json['role'] as String)
          : UserRole.guest,
      imageId: json['imageId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      verified: json['verified'] as bool? ?? false,
      emailAccountType: json['emailAccountType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'bio': bio,
      'generalSettings': generalSettings?.toJson(),
      'role': role.value,
      'imageId': imageId,
      'imageUrl': imageUrl,
      'verified': verified,
      'emailAccountType': emailAccountType,
    };
  }

  final String id;
  final String fullName;
  final String email;
  final String? bio;
  final GeneralSettingsDto? generalSettings;
  final UserRole role;
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
      image: imageUrl != null ? ImageInput.fromUrl(imageUrl) : null,
      verified: verified,
    );
  }
}

extension UserDomainX on User {
  UserDto get toDto {
    return UserDto(
      id: id.getOrCrash(),
      email: email.getOrCrash(),
      fullName: fullName.getOrCrash(),
      bio: bio?.getOrNull(),
      generalSettings: generalSettings?.toDto,
      role: role,
      emailAccountType: emailAccountType,
      imageId: imageId,
      imageUrl: switch (image?.getOrNull()) {
        NetworkImageOrigin(:final url) => url,
        LocalImageOrigin(:final file) => file.path,
        _ => null,
      },
      verified: verified,
    );
  }
}
