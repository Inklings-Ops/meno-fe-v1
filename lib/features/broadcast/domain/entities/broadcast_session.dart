import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';

class BroadcastSession with EquatableMixin {
  const BroadcastSession({required this.broadcast, required this.timestamp});

  factory BroadcastSession.create(Broadcast broadcast) {
    return BroadcastSession(broadcast: broadcast, timestamp: DateTime.now());
  }

  final Broadcast broadcast;
  final DateTime timestamp;

  bool get isValid => broadcast.isValid;

  /// Helper to check if the session is "stale" (e.g., > 12 hours old)
  bool get isExpired {
    final difference = DateTime.now().difference(timestamp);
    return difference.inHours > 12;
  }

  @override
  List<Object?> get props => [broadcast, timestamp];
}
