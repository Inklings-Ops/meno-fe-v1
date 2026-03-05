import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/model/dtos/user_dto.dart';
import 'package:meno/features/auth/model/model.dart';

final class UserCredentialDto {
  const UserCredentialDto({
    required this.token,
    required this.user,
    this.refreshToken,
    this.expiry,
  });

  factory UserCredentialDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw FormatError<UserCredentialDto>();
    return UserCredentialDto(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiry: json['expiry'] as String?,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'refreshToken': refreshToken,
    'expiry': expiry,
    'user': user.toJson(),
  };

  final String token;
  final String? refreshToken;
  final String? expiry;
  final UserDto user;
}

extension UserCredentialDtoX on UserCredentialDto {
  UserCredential get toDomain {
    return UserCredential(
      user: user.toDomain,
      session: Session.fromDto(
        token,
        refreshToken: refreshToken,
        explicitExpiry: expiry != null ? DateTime.tryParse(expiry!) : null,
      ),
    );
  }
}

extension UserCredentialX on UserCredential {
  UserCredentialDto get toDto {
    return UserCredentialDto(
      token: session.accessToken.getOrCrash(),
      refreshToken: session.refreshToken.getOrNull(),
      expiry: session.expiry?.toIso8601String(),
      user: user.toDto,
    );
  }
}
