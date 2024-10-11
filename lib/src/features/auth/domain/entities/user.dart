import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'user.freezed.dart';

/// A string representing a user's unique identifier.
typedef UserID = String;

/// Represents a user in the application.
@freezed
class User with _$User {
  /// Creates a new `User` object.
  const factory User({
    /// The user's unique identifier.
    required Uid<User> id,

    /// The user's full name.
    required SingleLineString fullName,

    /// The user's email address.
    required Email email,

    /// The user's bio.
    Bio? bio,

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
  }) = _User;

  /// Creates a new `User` object with all of the properties set to their 
  /// default values.
  factory User.empty() {
    return User(
      id: Uid.fromString(''),
      fullName: SingleLineString(''),
      bio: Bio(''),
      email: Email(''),
      emailAccountType: '',
      verified: false,
      imageId: '',
      imageUrl: '',
    );
  }
}
