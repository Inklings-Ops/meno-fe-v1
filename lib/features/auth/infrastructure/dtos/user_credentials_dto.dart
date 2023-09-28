import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_dto.dart';

part 'user_credentials_dto.freezed.dart';
part 'user_credentials_dto.g.dart';

/// A data transfer object (DTO) representing a user's credentials.
@freezed
@JsonSerializable(explicitToJson: true, createFactory: false)
class UserCredentialsDto with _$UserCredentialsDto {
  /// Creates a new `UserCredentialsDto` object.
  factory UserCredentialsDto({
    /// The user's DTO.
    required UserDto userDto,

    /// The user's token.
    required String token,
  }) = _UserCredentialsDto;

  /// Creates a new `UserCredentialsDto` object from a JSON map.
  factory UserCredentialsDto.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialsDtoFromJson(json);

  /// Converts the `UserCredentialsDto` object to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$UserCredentialsDtoToJson(this);
}
