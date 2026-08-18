import 'package:equatable/equatable.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/features/broadcast/model/entities/_entities.dart';

class BroadcastSession with EquatableMixin {
  const BroadcastSession({
    required this.currentUserId,
    required this.broadcast,
    required this.timestamp,
  });

  factory BroadcastSession.create(Id currentUserId, Broadcast broadcast) {
    return BroadcastSession(
      currentUserId: currentUserId,
      broadcast: broadcast,
      timestamp: DateTime.now(),
    );
  }

  final Id currentUserId;
  final Broadcast broadcast;
  final DateTime timestamp;

  static BroadcastSession empty = BroadcastSession(
    currentUserId: .empty,
    broadcast: .empty,
    timestamp: DateTime(0001),
  );

  bool get isValid => broadcast.isValid;

  /// Helper to check if the session is "stale" (e.g., > 12 hours old)
  bool get isExpired {
    final difference = DateTime.now().difference(timestamp);
    return difference.inHours > 12;
  }

  @override
  List<Object?> get props => [currentUserId, broadcast, timestamp];
}
