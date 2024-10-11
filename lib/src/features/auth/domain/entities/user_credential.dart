import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/auth/domain/entities/user.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'user_credential.freezed.dart';

/// Represents a user's credentials.
@freezed
class UserCredential with _$UserCredential {
  /// Creates a new `UserCredentials` object.
  const factory UserCredential({
    /// The user.
    required User user,

    /// The user's token.
    Token? token,
  }) = _UserCredential;

  /// Creates a new `UserCredentials` object with all of the properties set to
  /// their default values.
  factory UserCredential.empty() {
    return UserCredential(
      user: User.empty(),
      token: Token(''),
    );
  }

  factory UserCredential.fromUI(User user, [Token? token]) {
    return UserCredential(user: user, token: token);
  }
}
