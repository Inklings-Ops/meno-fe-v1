import 'package:equatable/equatable.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/shared/infrastructure/dtos/user_dto.dart';

class UserCredentialDto with EquatableMixin {
  const UserCredentialDto({
    required this.token,
    required this.user,
    this.refreshToken,
    this.expiry,
  });

  factory UserCredentialDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON type for UserCredentialDto: $json');
    }

    return UserCredentialDto(
      token: json[_kToken] as String,
      refreshToken: json[_kRefreshToken] as String?,
      expiry: json[_kExpiry] as String?,
      user: UserDto.fromJson(json[_kUser]),
    );
  }

  static const _kToken = 'token';
  static const _kRefreshToken = 'refreshToken';
  static const _kExpiry = 'expiry';
  static const _kUser = 'user';

  Map<String, dynamic> toJson() => {
    _kToken: token,
    _kRefreshToken: refreshToken,
    _kExpiry: expiry,
    _kUser: user.toJson(),
  };

  final String token;
  final String? refreshToken;
  final String? expiry;
  final UserDto user;

  @override
  List<Object?> get props => [token, refreshToken, expiry, user];
}

extension UserCredentialDtoX on UserCredentialDto {
  UserCredential get toDomain {
    return UserCredential(
      user: user.toDomain,
      session: Session.fromDto(
        token,
        refreshToken: refreshToken,
        // If we have an expiry string from disk, parse it.
        // This prevents the Session from needing to decode the JWT again.
        explicitExpiry: expiry != null ? DateTime.tryParse(expiry!) : null,
      ),
    );
  }
}

extension UserCredentialDomainX on UserCredential {
  UserCredentialDto get toDto {
    return UserCredentialDto(
      token: session.accessToken.getOrElse((_) => ''),
      refreshToken: session.refreshToken.getOrNull(),
      expiry: session.expiry?.toIso8601String(),
      user: user.toDto,
    );
  }
}
