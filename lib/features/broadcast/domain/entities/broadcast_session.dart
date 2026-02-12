import 'package:equatable/equatable.dart';
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/shared/domain/domain.dart';

class BroadcastSession with EquatableMixin {
  const BroadcastSession({
    required this.broadcastId,
    required this.broadcastToken,
    required this.timestamp,
    required this.creatorId,
  });

  factory BroadcastSession.fromBroadcast(Broadcast broadcast) {
    final token = broadcast.broadcastToken;
    if (token == null) throw const MenoException('Invalid broadcast token');

    final creatorId = broadcast.effectiveCreatorId;
    if (creatorId.isEmpty) throw const MenoException('Invalid creator ID');

    return BroadcastSession(
      broadcastId: broadcast.id,
      broadcastToken: token,
      timestamp: DateTime.now(),
      creatorId: creatorId,
    );
  }

  final Id broadcastId;
  final String broadcastToken;
  final DateTime timestamp;
  final Id creatorId;

  bool get isValid =>
      broadcastId.isValid && broadcastToken.isNotEmpty && creatorId.isValid;

  /// Helper to check if the session is "stale" (e.g., > 12 hours old)
  bool get isExpired {
    final difference = DateTime.now().difference(timestamp);
    return difference.inHours > 12;
  }

  @override
  List<Object?> get props => [
    broadcastId,
    broadcastToken,
    timestamp,
    creatorId,
  ];
}
