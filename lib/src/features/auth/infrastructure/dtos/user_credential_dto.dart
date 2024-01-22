import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_dto.dart';

part 'user_credential_dto.freezed.dart';
part 'user_credential_dto.g.dart';

/// A data transfer object (DTO) representing a user's credentials.
@freezed
@JsonSerializable(explicitToJson: true, createFactory: false)
class UserCredentialDto with _$UserCredentialDto {
  /// Creates a new `UserCredentialDto` object.
  factory UserCredentialDto({
    /// The user's DTO.
    required UserDto user,

    /// The user's token.
    String? token,
  }) = _UserCredentialDto;

  /// Creates a new `UserCredentialDto` object from a JSON map.
  factory UserCredentialDto.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialDtoFromJson(json);

  /// Converts the `UserCredentialDto` object to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$UserCredentialDtoToJson(this);
}
