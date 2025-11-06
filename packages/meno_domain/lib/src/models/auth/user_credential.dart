import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_domain/src/models/auth/user.dart';

part 'user_credential.freezed.dart';

part 'user_credential.g.dart';

/// Represents the credentials returned after a successful authentication event.
///
/// This class is a data-transfer object that bundles the authentication token
/// together with the authenticated [User] details. It is typically created
/// after a user signs in or signs up.
///
/// It uses the `freezed` package to generate boilerplate code for
/// immutability and equality.
@freezed
abstract class UserCredential with _$UserCredential {
  /// Creates an instance of [UserCredential].
  ///
  /// This constructor is private and is used by the `freezed` package.
  /// Public instances should be created via the public factory constructor.
  const factory UserCredential({
    /// The authentication token (e.g., JWT) required for making authenticated
    /// API requests.
    required String token,

    /// The authenticated [User] object containing the user's profile data.
    required User user,
  }) = _UserCredential;

  /// A factory constructor for a [UserCredential] instance from a JSON map.
  ///
  /// This is used for deserializing the credential data, typically from a
  /// network response after a successful sign-in or sign-up.
  factory UserCredential.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialFromJson(json);
}
