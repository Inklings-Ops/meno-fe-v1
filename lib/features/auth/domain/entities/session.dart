import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meno/features/auth/domain/domain.dart';

final class Session with EquatableMixin {
  const Session({
    required this.accessToken,
    required this.refreshToken,
    required this.expiry,
  });

  factory Session.fromDto(String accessToken, {String? refreshToken}) {
    DateTime? expiry;

    try {
      if (accessToken.isNotEmpty) {
        final decoded = JwtDecoder.decode(accessToken);
        if (decoded.containsKey('exp')) {
          final value = decoded['exp'];
          if (value is! int) throw Exception('Invalid token');
          expiry = DateTime.fromMillisecondsSinceEpoch(value * 1000);
        }
      }
    } on Exception catch (e) {
      // Token is invalid or opaque, ignore expiry
      debugPrint('Token is invalid or opaque, ignoring expiry: $e');
    }

    return Session(
      accessToken: Token(accessToken),
      refreshToken: Token.orEmpty(refreshToken),
      expiry: expiry,
    );
  }

  final Token accessToken;
  final Token refreshToken;
  final DateTime? expiry;

  @override
  List<Object?> get props => [accessToken, refreshToken, expiry];

  bool get isExpired {
    if (expiry == null) return false;
    return DateTime.now().isAfter(expiry!);
  }
}
