import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// A data transfer object (DTO) representing a user.
@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class UserDto with _$UserDto {
  /// Creates a new `UserDto` object.
  factory UserDto({
    /// The user's ID.
    required String id,

    /// The user's full name.
    required String fullName,

    /// The user's email address.
    required String email,

    /// The user's bio.
    String? bio,

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
  }) = _UserDto;

  /// Creates a new `UserDto` object from a JSON map.
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  /// Converts the `UserDto` object to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
