import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'user_credential.freezed.dart';

/// A typedef representing a user token.
typedef UserToken = String;

/// Represents a user's credentials.
@freezed
class UserCredential with _$UserCredential {
  /// Creates a new `UserCredentials` object.
  const factory UserCredential({
    /// The user.
    required User user,

    /// The user's token.
    UserToken? token,
  }) = _UserCredential;

  /// Creates a new `UserCredentials` object with all of the properties set to their default values.
  factory UserCredential.empty() {
    return UserCredential(
      user: User.empty(),
      token: '',
    );
  }
}
