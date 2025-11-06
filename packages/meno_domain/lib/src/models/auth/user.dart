import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_domain/meno_domain.dart';
import 'package:meno_domain/src/converters/converters.dart';

part 'user.freezed.dart';

part 'user.g.dart';

/// Represents a user account in the application.
///
/// This is an immutable entity class that holds all the information related
/// to a specific user, such as their identification, profile details, and
/// settings. It uses the `freezed` package to generate boilerplate code for
/// immutability and equality.
@freezed
abstract class User with _$User {
  /// Creates an instance of the [User] entity.
  const factory User({
    @IdConverter() required Id id,
    @SingleLineStringConverter() required SingleLineString fullName,
    @EmailConverter() required Email email,
    @MultiLineStringConverter() MultiLineString? bio,
    Settings? generalSettings,
    UserRole? role,
    String? imageId,
    @ImageObjectConverter() ImageObject? imageUrl,
    @Default(false) bool verified,
    String? emailAccountType,
  }) = _User;

  /// A factory constructor to create a [User] instance from a JSON map.
  ///
  /// This is used for deserializing user data, typically from a network
  /// response.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
