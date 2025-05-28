import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

part 'user_credential_dto.g.dart';

@JsonSerializable()
class UserCredentialDto with EquatableMixin {
  const UserCredentialDto({required this.token, required this.user});

  factory UserCredentialDto.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserCredentialDtoToJson(this);

  final String token;
  final UserDto user;

  @override
  List<Object?> get props => [token, user];

  @override
  bool get stringify => true;
}

extension UserCredentialDtoX on UserCredentialDto {
  UserCredentialDto get stripped {
    return UserCredentialDto(
      user: user.stripped,
      token: token,
    );
  }

  UserCredential get toDomain {
    return UserCredential(
      user: user.toDomain,
      token: Token(token),
    );
  }
}

extension UserCredentialToDtoX on UserCredential {
  UserCredentialDto get toDto {
    return UserCredentialDto(
      user: user.toDto,
      token: token.getOrElse(() => ''),
    );
  }
}
