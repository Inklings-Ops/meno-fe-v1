import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'user_credentials.freezed.dart';

/// A typedef representing a user token.
typedef UserToken = String;

/// Represents a user's credentials.
@freezed
class UserCredentials with _$UserCredentials {
  /// Creates a new `UserCredentials` object.
  const factory UserCredentials({
    /// The user.
    required User user,

    /// The user's token.
    required UserToken token,
  }) = _UserCredentials;

  /// Creates a new `UserCredentials` object with all of the properties set to their default values.
  factory UserCredentials.empty() {
    return UserCredentials(
      user: User.empty(),
      token: '',
    );
  }
}
