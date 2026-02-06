import 'package:equatable/equatable.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/shared/infrastructure/dtos/user_dto.dart';

class UserCredentialDto with EquatableMixin {
  const UserCredentialDto({
    required this.token,
    required this.user,
    this.refreshToken,
  });

  factory UserCredentialDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON type for UserCredentialDto: $json');
    }

    return UserCredentialDto(
      token: json[_kToken] as String,
      refreshToken: json[_kRefreshToken] as String?,
      user: UserDto.fromJson(json[_kUser]),
    );
  }

  static const _kToken = 'token';
  static const _kRefreshToken = 'refreshToken';
  static const _kUser = 'user';

  Map<String, dynamic> toJson() => {
    _kToken: token,
    _kRefreshToken: refreshToken,
    _kUser: user.toJson(),
  };

  final String token;
  final String? refreshToken;
  final UserDto user;

  @override
  List<Object?> get props => [token, refreshToken, user];
}

extension UserCredentialDtoX on UserCredentialDto {
  UserCredential toDomain() {
    return UserCredential(
      user: user.toDomain,
      session: Session.fromDto(token, refreshToken: refreshToken),
    );
  }
}

extension UserCredentialDomainX on UserCredential {
  UserCredentialDto toDto() {
    return UserCredentialDto(
      token: session.accessToken.getOrElse((_) => ''),
      refreshToken: session.refreshToken.getOrNull(),
      user: user.toDto,
    );
  }
}
