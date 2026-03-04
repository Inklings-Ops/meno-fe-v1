import 'package:equatable/equatable.dart';
import 'package:meno/src/_shared/models/models.dart';

enum UserRole {
  admin('admin'),
  guest('guest');

  const UserRole(this.value);

  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserRole.guest,
    );
  }
}

final class User with EquatableMixin {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.bio,
    this.generalSettings,
    this.role,
    this.imageId,
    this.image,
    this.verified = false,
    this.emailAccountType,
  });

  final Id id;
  final SingleLineString fullName;
  final Email email;
  final MultiLineString? bio;
  final GeneralSettings? generalSettings;
  final UserRole? role;
  final String? imageId;
  final ImageInput? image;
  final bool verified;
  final String? emailAccountType;

  static const User empty = User(
    id: Id.empty,
    fullName: SingleLineString.empty,
    email: Email.empty,
    bio: MultiLineString.empty,
  );

  User copyWith({
    Id? id,
    SingleLineString? fullName,
    Email? email,
    MultiLineString? bio,
    GeneralSettings? generalSettings,
    UserRole? role,
    String? imageId,
    ImageInput? image,
    bool? verified,
    String? emailAccountType,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      generalSettings: generalSettings ?? this.generalSettings,
      role: role ?? this.role,
      imageId: imageId ?? this.imageId,
      image: image ?? this.image,
      verified: verified ?? this.verified,
      emailAccountType: emailAccountType ?? this.emailAccountType,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    bio,
    generalSettings,
    role,
    imageId,
    image,
    verified,
    emailAccountType,
  ];
}

extension UserX on User {
  bool get isValid => id.isValid && fullName.isValid && email.isValid;

  bool get isEmpty => this == User.empty;
}
