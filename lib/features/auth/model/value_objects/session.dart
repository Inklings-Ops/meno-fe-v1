import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meno/features/auth/model/value_objects/token.dart';

final class Session with EquatableMixin {
  const Session({
    required this.accessToken,
    required this.refreshToken,
    required this.expiry,
  });

  factory Session.fromDto(
    String accessToken, {
    String? refreshToken,
    DateTime? explicitExpiry,
  }) {
    var expiry = explicitExpiry;

    if (expiry == null && accessToken.isNotEmpty) {
      try {
        final decoded = JwtDecoder.decode(accessToken);
        if (decoded.containsKey('exp')) {
          final value = decoded['exp'];
          if (value is int) {
            expiry = DateTime.fromMillisecondsSinceEpoch(value * 1000);
          }
        }
      } on Exception {
        // Token invalid/opaque - ignore
      }
    }

    return Session(
      accessToken: Token(accessToken),
      refreshToken: Token.orEmpty(refreshToken),
      expiry: expiry,
    );
  }

  static Session empty = Session(
    accessToken: Token.orEmpty(''),
    refreshToken: Token.orEmpty(''),
    expiry: null,
  );

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

extension SessionX on Session {
  bool shouldRefresh({Duration threshold = const Duration(minutes: 5)}) {
    if (refreshToken.getOrNull() == null) return false;
    if (expiry == null) return false;
    if (isExpired) return true;

    final now = DateTime.now();
    final refreshThreshold = expiry!.subtract(threshold);
    return now.isAfter(refreshThreshold);
  }

  bool get isRefreshable => refreshToken.getOrNull() != null && expiry != null;

  Duration? get timeUntilExpiry {
    if (expiry == null) return null;
    final now = DateTime.now();
    return expiry!.difference(now);
  }

  bool isExpiringSoon({Duration threshold = const Duration(minutes: 5)}) {
    if (expiry == null) return false;
    if (isExpired) return true;

    final remaining = timeUntilExpiry;
    return remaining != null && remaining < threshold;
  }
}
