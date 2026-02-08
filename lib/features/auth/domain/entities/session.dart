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

  factory Session.fromDto(
    String accessToken, {
    String? refreshToken,
    DateTime? explicitExpiry,
  }) {
    var expiry = explicitExpiry;

    // Only decode if we didn't provide an expiry
    if (expiry == null && accessToken.isNotEmpty) {
      try {
        final decoded = JwtDecoder.decode(accessToken);
        if (decoded.containsKey('exp')) {
          final value = decoded['exp'];
          if (value is int) {
            expiry = DateTime.fromMillisecondsSinceEpoch(value * 1000);
          }
        }
      } on Exception catch (e) {
        debugPrint('Token invalid/opaque: $e');
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
  /// Whether this session should be refreshed.
  ///
  /// Returns true if:
  /// - Token is expired OR
  /// - Token expires within [threshold] (default 5 minutes)
  ///
  /// Returns false if:
  /// - No refresh token available
  /// - No expiry information (opaque tokens)
  bool shouldRefresh({Duration threshold = const Duration(minutes: 5)}) {
    // Can't refresh without a refresh token
    if (refreshToken.getOrNull() == null) return false;

    // No expiry info - assume valid (opaque token)
    if (expiry == null) return false;

    // Already expired
    if (isExpired) return true;

    // Expiring soon
    final now = DateTime.now();
    final refreshThreshold = expiry!.subtract(threshold);
    return now.isAfter(refreshThreshold);
  }

  /// Whether this session can be refreshed.
  ///
  /// A session is refreshable if it has both:
  /// - A valid refresh token
  /// - Expiry information
  bool get isRefreshable => refreshToken.getOrNull() != null && expiry != null;

  /// Time remaining until token expires.
  /// Returns null if no expiry information.
  Duration? get timeUntilExpiry {
    if (expiry == null) return null;
    final now = DateTime.now();
    return expiry!.difference(now);
  }

  /// Whether the session is about to expire (within threshold).
  bool isExpiringSoon({Duration threshold = const Duration(minutes: 5)}) {
    if (expiry == null) return false;
    if (isExpired) return true;

    final remaining = timeUntilExpiry;
    return remaining != null && remaining < threshold;
  }
}
