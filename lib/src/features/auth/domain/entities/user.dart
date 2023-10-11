import 'package:freezed_annotation/freezed_annotation.dart';

import '../inputs/inputs.dart';

part 'user.freezed.dart';

/// A string representing a user's unique identifier.
typedef UserID = String;

/// Represents a user in the application.
@freezed
class User with _$User {
  /// Creates a new `User` object.
  factory User({
    /// The user's unique identifier.
    required UserID id,

    /// The user's full name.
    required IFullName fullName,

    /// The user's email address.
    required IEmail email,

    /// The user's bio.
    IBio? bio,

    /// The type of email account the user uses.
    String? emailAccountType,

    /// Whether the user's email address has been verified.
    required bool verified,

    /// The ID of the user's profile image.
    String? imageId,

    /// The URL of the user's profile image.
    String? imageUrl,

    /// Whether the user has been deleted.
    dynamic deleted,
  }) = _User;

  /// Creates a new `User` object with all of the properties set to their default values.
  factory User.empty() {
    return User(
      id: '',
      fullName: IFullName(''),
      bio: IBio(''),
      email: IEmail(''),
      emailAccountType: '',
      verified: false,
      imageId: '',
      imageUrl: '',
      deleted: null,
    );
  }
}
